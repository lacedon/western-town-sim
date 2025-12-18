extends Node2D

class_name BuildingNode

enum BuildingMode {
  planing,
  built
}

@onready var sprite: Sprite2D = $Sprite2D
@onready var sizeDebugBlock: ColorRect = $SizeDebugBlock

@export var mode: BuildingMode = BuildingMode.planing
@export var building: RBuilding = null

func _ready() -> void:
  _initBuilding()

func _initBuilding() -> void:
  if !building: return _resetBuilding()

  sprite.texture = building.texture
  sprite.modulate = Color(1, 1, 1, 0.5)

  var sizeInPixels: Vector2i = building.size * GameConfig.tileSize
  sizeDebugBlock.custom_minimum_size = sizeInPixels
  sizeDebugBlock.position = -sizeInPixels / 2
  sizeDebugBlock.color = Color(0.25, 1, 0.5, 0.5)
  sizeDebugBlock.show()

func _resetBuilding() -> void:
  sprite.texture = null

  sizeDebugBlock.custom_minimum_size = Vector2i.ZERO
  sizeDebugBlock.hide()


func setBuilding(_building: RBuilding) -> void:
  building = _building
  _initBuilding()
