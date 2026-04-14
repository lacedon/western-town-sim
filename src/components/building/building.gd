extends Node2D
class_name BuildingNode

const CoordinateParser = preload("res://src/common/coordinate_parser.gd")
const BuildingScene = preload('./building.tscn')

enum BuildingMode {
  builder,
  planing,
  placed,
}

const ModeColors = {
  planing_success = Color(.25, 1, .25, .25),
  planing_error = Color(1, .25, .25, .25),
  normal = Color(1, 1, 1, 0),
}

@onready var _sprite: Sprite2D = $Sprite2D
@onready var _coloring_block: ColorRect = $ColoringBlock
@onready var _collision_area: Area2D = $Area2D
@onready var _collision_object: CollisionShape2D = $Area2D/CollisionShape2D

@export var mode: BuildingMode = BuildingMode.planing
@export var building: RBuilding = null
@export var collision_offset: Vector2 = Vector2(2, 2)

var _building_size_px: Vector2 = Vector2.ZERO
var _top_left_edge_position: Vector2 = Vector2.ZERO

static func clone(original_building: BuildingNode) -> BuildingNode:
  return BuildingNode.create(original_building.building, original_building.mode, original_building.position)

static func create(_building: RBuilding, _mode := BuildingMode.planing, _position := Vector2.ZERO) -> BuildingNode:
  var created_building: BuildingNode = BuildingScene.instantiate()
  created_building.position = _position
  created_building.building = _building
  created_building.mode = _mode
  return created_building

func _ready() -> void:
  if !self.visible:
    set_mode(BuildingMode.planing)
    _collision_area.monitorable = false
    _collision_area.monitoring = false
    return

  _init_building()

  if mode != BuildingMode.builder:
    StateController.day_timer.start_of_day.connect(_handle_start_of_day)

  if mode == BuildingMode.placed:
    _handle_mode_set_placed()

  _collision_area.connect(_collision_area.area_entered.get_name(), _handle_area_enter_exit)
  _collision_area.connect(_collision_area.area_exited.get_name(), _handle_area_enter_exit)

func _exit_tree() -> void:
  _collision_area.disconnect(_collision_area.area_entered.get_name(), _handle_area_enter_exit)
  _collision_area.disconnect(_collision_area.area_exited.get_name(), _handle_area_enter_exit)

  if mode != BuildingMode.builder:
    StateController.day_timer.start_of_day.disconnect(_handle_start_of_day)

func _init_building(_new_building: RBuilding = null) -> void:
  prints(self, "_init_building", building, _new_building)
  if _new_building:
    building = _new_building.clone_at(CoordinateParser.pixels_to_game_tiles(self.position))
  elif building:
    building.position_gt = CoordinateParser.pixels_to_game_tiles(self.position)

  if !building: return _reset_building()

  _building_size_px = CoordinateParser.game_tiles_to_pixels(building.size)
  _top_left_edge_position = -Vector2(float(_building_size_px.x / 2), float(_building_size_px.y / 2))

  _sprite.texture = building.texture

  _coloring_block.size = _building_size_px
  _coloring_block.position = _top_left_edge_position
  update_coloring()
  _coloring_block.show()

  _collision_object.shape.size = _building_size_px - collision_offset
  _collision_object.position = Vector2.ONE

  _collision_area.show()
  _collision_area.monitorable = mode == BuildingMode.placed
  _collision_area.monitoring = mode == BuildingMode.planing || mode == BuildingMode.builder

func _reset_building() -> void:
  _building_size_px = Vector2.ZERO
  _sprite.texture = null
  _coloring_block.hide()
  _collision_area.hide()

func _handle_area_enter_exit(_area: Area2D) -> void:
  update_coloring()

func set_building(_building: RBuilding) -> void:
  prints("set_building", _building)
  _init_building(_building)

func can_be_placed() -> bool:
  return !_collision_area.has_overlapping_areas()

func set_mode(new_mode: BuildingMode) -> void:
  mode = new_mode
  update_coloring()

  if mode == BuildingMode.placed:
    _handle_mode_set_placed()

func update_coloring() -> void:
  match mode:
    BuildingMode.builder:
      _coloring_block.color = ModeColors.planing_success if can_be_placed() else ModeColors.planing_error
    BuildingMode.planing:
      _coloring_block.color = ModeColors.planing_success if can_be_placed() else ModeColors.planing_error
    _:
      _coloring_block.color = ModeColors.normal

func _emit_obstacle_added_event() -> void:
  StateController.navigation_server.add_environment_obstacle(
    position - Vector2(float(_building_size_px.x / 2), float(_building_size_px.y / 2)),
    _building_size_px
  )

func _handle_mode_set_placed() -> void:
  _emit_obstacle_added_event()
  _create_entrance()

func _create_entrance() -> void:
  for entrance in building.entrances:
    var entranceNode: ColorRect = ColorRect.new()
    entranceNode.color = Color(0, 0.75, 0.95, 0.25)
    entranceNode.size = GameConfig.tile_size
    entranceNode.position = _top_left_edge_position + CoordinateParser.game_tiles_to_pixels(entrance)
    add_child(entranceNode)

func _handle_start_of_day() -> void:
  if self.building && self.mode == BuildingMode.placed:
    self.building.on_day_change()
