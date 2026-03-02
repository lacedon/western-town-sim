extends Node2D

class_name BuildingNode

signal areaEnteredExited
signal add_environment_obstacle(position: Vector2, size: Vector2i)

const BuildingScene = preload('./building.tscn')
const events = preload('res://src/constants/events.gd')

enum BuildingMode {
  planing,
  placed,
}

const ModeColors = {
  planingSuccess = Color(.25, 1, .25, .25),
  planingError = Color(1, .25, .25, .25),
  normal = Color(1, 1, 1, 0),
}

@onready var sprite: Sprite2D = $Sprite2D
@onready var coloringBlock: ColorRect = $ColoringBlock
@onready var area2d: Area2D = $Area2D
@onready var collisionObject: CollisionShape2D = $Area2D/CollisionShape2D

@export var mode: BuildingMode = BuildingMode.planing
@export var building: RBuilding = null

static func clone(originalBuilding: BuildingNode) -> BuildingNode:
  return BuildingNode.create(originalBuilding.building, originalBuilding.mode, originalBuilding.position)

static func create(_building: RBuilding, _mode: = BuildingMode.planing, _position: = Vector2.ZERO) -> BuildingNode:
  var createdBuilding: BuildingNode = BuildingScene.instantiate()
  createdBuilding.position = _position
  createdBuilding.building = _building
  createdBuilding.mode = _mode
  return createdBuilding

func _ready() -> void:
  if !self.visible:
    setMode(BuildingMode.planing)
    area2d.monitorable = false
    area2d.monitoring = false
    return

  _initBuilding()

  EventEmitter.add_emitter(events.ADD_ENVIRONMENT_OBSTACLE, self)
  EventEmitter.add_listener(events.START_OF_DAY, _handle_start_of_day)

  if mode == BuildingMode.placed:
    handleModeSetPlaced()

  area2d.connect(area2d.area_entered.get_name(), _emitAreaEnteredExited)
  area2d.connect(area2d.area_exited.get_name(), _emitAreaEnteredExited)

func _exit_tree() -> void:
  area2d.disconnect(area2d.area_entered.get_name(), _emitAreaEnteredExited)
  area2d.disconnect(area2d.area_exited.get_name(), _emitAreaEnteredExited)

  EventEmitter.remove_emitter(events.ADD_ENVIRONMENT_OBSTACLE, self)
  EventEmitter.remove_listener(events.START_OF_DAY, _handle_start_of_day)

func _initBuilding() -> void:
  if !building: return _resetBuilding()

  var buildingSizeInPixels: Vector2i = building.size * GameConfig.tile_size
  var buildingCenteringPosition: Vector2 = -buildingSizeInPixels / 2

  sprite.texture = building.texture

  coloringBlock.size = buildingSizeInPixels
  coloringBlock.position = buildingCenteringPosition
  updateColoring()
  coloringBlock.show()

  collisionObject.shape.size = buildingSizeInPixels - Vector2i(2, 2)
  collisionObject.position = Vector2i.ONE

  area2d.show()
  area2d.monitorable = mode == BuildingMode.placed
  area2d.monitoring = mode == BuildingMode.planing

func _resetBuilding() -> void:
  sprite.texture = null
  coloringBlock.hide()
  area2d.hide()

func _emitAreaEnteredExited(_area: Area2D) -> void:
  emit_signal(areaEnteredExited.get_name())

func setBuilding(_building: RBuilding) -> void:
  building = _building
  _initBuilding()

func canBePlaced() -> bool:
  return !area2d.has_overlapping_areas()

func setMode(newMode: BuildingMode) -> void:
  mode = newMode
  updateColoring()

  if mode == BuildingMode.placed:
    handleModeSetPlaced()

func updateColoring() -> void:
  match mode:
    BuildingMode.planing:
      coloringBlock.color = ModeColors.planingSuccess if canBePlaced() else ModeColors.planingError
    _:
      coloringBlock.color = ModeColors.normal

func emitObstacleAddedEvent() -> void:
  var sizeInPixels: Vector2 = building.size * GameConfig.tile_size
  add_environment_obstacle.emit(
    position - Vector2(float(sizeInPixels.x / 2), float(sizeInPixels.y / 2)),
    sizeInPixels
  )

func handleModeSetPlaced() -> void:
  emitObstacleAddedEvent()
  createEntrance()

func get_top_left_edge_position() -> Vector2:
  var buildingSizePixels: Vector2 = building.size * GameConfig.tile_size
  return Vector2(-float(buildingSizePixels.x / 2), -float(buildingSizePixels.y / 2))

func createEntrance() -> void:
  var top_left_edge_position: Vector2 = self.get_top_left_edge_position()

  for entrance in building.entrances:
    var entranceNode: Polygon2D = Polygon2D.new()
    entranceNode.color = Color(0, 0.75, 0.95, 0.25)
    entranceNode.polygon = PackedVector2Array([
      Vector2(0, 0),
      Vector2(GameConfig.tile_size.x, 0),
      Vector2(GameConfig.tile_size.x, GameConfig.tile_size.y),
      Vector2(0, GameConfig.tile_size.y)
    ])
    entranceNode.position = top_left_edge_position + Vector2(entrance.x * GameConfig.tile_size.x, entrance.y * GameConfig.tile_size.y)
    add_child(entranceNode)

func _handle_start_of_day() -> void:
  if self.building && self.mode == BuildingMode.placed:
    self.building.on_day_change((self.position + self.get_top_left_edge_position()) / Vector2(GameConfig.tile_size))
