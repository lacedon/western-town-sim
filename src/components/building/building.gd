extends Node2D

class_name BuildingNode

enum BuildingMode {
  planing,
  built
}

@onready var sprite: Sprite2D = $Sprite2D
@onready var sizeDebugBlock: ColorRect = $SizeDebugBlock
@onready var area2d: Area2D = $Area2D
@onready var collisionObject: CollisionShape2D = $Area2D/CollisionShape2D

@export var mode: BuildingMode = BuildingMode.planing
@export var building: RBuilding = null

func _ready() -> void:
  _initBuilding()

func _initBuilding() -> void:
  if !building: return _resetBuilding()

  var buildingSizeInPixels: Vector2i = building.size * GameConfig.tileSize
  var buildingCenteringPosition: Vector2 = -buildingSizeInPixels / 2

  sprite.texture = building.texture
  sprite.modulate = Color(1, 1, 1, 0.5)

  sizeDebugBlock.custom_minimum_size = buildingSizeInPixels
  sizeDebugBlock.position = buildingCenteringPosition
  sizeDebugBlock.color = Color(0.25, 1, 0.5, 0.5)
  sizeDebugBlock.show()

  collisionObject.shape.size = buildingSizeInPixels

  area2d.show()

func _resetBuilding() -> void:
  sprite.texture = null

  sizeDebugBlock.custom_minimum_size = Vector2i.ZERO
  sizeDebugBlock.hide()

  area2d.hide()

func setBuilding(_building: RBuilding) -> void:
  building = _building
  _initBuilding()
