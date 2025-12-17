extends Node2D

class_name BuildingNode

enum BuildingMode {
  planing,
  built
}

@onready var sprite: Sprite2D = $Sprite2D

@export var mode: BuildingMode = BuildingMode.planing
@export var building: RBuilding = null

func setBuilding(_building: RBuilding) -> void:
  building = _building

  sprite.texture = building.texture if building else null
