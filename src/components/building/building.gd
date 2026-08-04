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
@onready var _places_icons_container: Control = $PlacesIcons

@export var mode: BuildingMode = BuildingMode.planing
@export var building: RBuilding = null
@export var building_state: RBuildingState = RBuildingState.new()
@export var collision_offset: Vector2 = Vector2(2, 2)

var _building_size_px: Vector2 = Vector2.ZERO
var _top_left_edge_position_px: Vector2 = Vector2.ZERO

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
  _redraw_unit_icons()

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

  if mode == BuildingMode.placed:
    building_state.units_inside_changed.disconnect(_redraw_unit_icons)

func _get_top_left_edge_position(building_size: Vector2) -> Vector2:
  return Vector2(floor(float(building_size.x) / 2), floor(float(building_size.y) / 2))

func _init_building() -> void:
  if !building:
    return _reset_building()

  building_state.building = building
  building_state.position_gt = CoordinateParser.pixels_to_game_tiles(self.position) - _get_top_left_edge_position(building.size)

  _building_size_px = CoordinateParser.game_tiles_to_pixels(building.size)
  _top_left_edge_position_px = -_get_top_left_edge_position(_building_size_px)

  _sprite.texture = building.texture

  _coloring_block.size = _building_size_px
  _coloring_block.position = _top_left_edge_position_px
  update_coloring()
  _coloring_block.show()

  _collision_object.shape.size = _building_size_px - collision_offset
  _collision_object.position = Vector2.ONE

  _collision_area.show()
  _collision_area.monitorable = mode == BuildingMode.placed
  _collision_area.monitoring = mode == BuildingMode.planing || mode == BuildingMode.builder

  _places_icons_container.position = _top_left_edge_position_px
  _places_icons_container.size = _building_size_px

func _reset_building() -> void:
  _building_size_px = Vector2.ZERO
  _sprite.texture = null
  _coloring_block.hide()
  _collision_area.hide()

func _handle_area_enter_exit(_area: Area2D) -> void:
  update_coloring()

func set_building(_building: RBuilding) -> void:
  building = _building
  _init_building()

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

func _redraw_unit_icons() -> void:
  for child in _places_icons_container.get_children():
    child.queue_free()

  var count := building_state.units_inside_workers.size()
  if count == 0:
    return

  var icon_size := Vector2(GameConfig.tile_size) / 3
  var center := _building_size_px / 2
  var radius: float = min(_building_size_px.x, _building_size_px.y) / 2 * 0.6
  var circle_count: int = max(count, 8)

  for i in count:
    var angle := 1.5 * PI + 2 * PI * (circle_count - i) / circle_count
    var icon := ColorRect.new()
    icon.color = Color(0.5, 1, 0.5, 0.8)
    icon.size = icon_size
    icon.position = center + Vector2(cos(angle), sin(angle)) * radius - icon_size / 2
    _places_icons_container.add_child(icon)

func _handle_mode_set_placed() -> void:
  _emit_obstacle_added_event()
  _create_entrance()
  building_state.units_inside_changed.connect(_redraw_unit_icons)

  if _provides_storage():
    add_to_group(&"storage_buildings")

func _provides_storage() -> bool:
  for function in building.functions:
    if function is BuildingFunctionStorage:
      return true
  return false

func _create_entrance() -> void:
  var building_top_left_edge = (
    _get_top_left_edge_position(building.size) +
    Vector2(
      (0 if building.size.x % 2 == 0 else 0.5),
      (0 if building.size.y % 2 == 0 else 0.5),
    )
  )
  for entrance in building.entrances:
    var entranceNode: BuildingEntrance = BuildingEntrance.create(
      entrance - building_top_left_edge
    )
    add_child(entranceNode)

func _handle_start_of_day() -> void:
  if self.building && self.mode == BuildingMode.placed:
    self.building.on_day_change(self.building_state)

func _process(delta: float) -> void:
  if self.building && self.mode == BuildingMode.placed:
    self.building.on_process(self.building_state, delta)
