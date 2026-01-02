extends Node2D

class_name BuildingNode

signal areaEnteredExited

const BuildingScene = preload('./building.tscn')

enum BuildingMode {
  planing,
  placed,
}

const ModeColors = {
  planingSuccess = Color(.25, 1, .25, .75),
  planingError = Color(1, .25, .25, .75),
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
  _initBuilding()

  area2d.connect(area2d.area_entered.get_name(), _emitAreaEnteredExited)
  area2d.connect(area2d.area_exited.get_name(), _emitAreaEnteredExited)

func _exit_tree() -> void:
  area2d.disconnect(area2d.area_entered.get_name(), _emitAreaEnteredExited)
  area2d.disconnect(area2d.area_exited.get_name(), _emitAreaEnteredExited)

func _initBuilding() -> void:
  if !building: return _resetBuilding()

  var buildingSizeInPixels: Vector2i = building.size * GameConfig.tileSize
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

func updateColoring() -> void:
  match mode:
    BuildingMode.planing:
      coloringBlock.color = ModeColors.planingSuccess if canBePlaced() else ModeColors.planingError
    _:
      coloringBlock.color = ModeColors.normal
