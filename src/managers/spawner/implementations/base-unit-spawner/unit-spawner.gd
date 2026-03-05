class_name UnitSpawner
extends "../../spawner.gd"

const events = preload("res://src/constants/events.gd")
const unit_scene = preload("res://src/components/unit/unit.tscn")

@export var unitsContainer: Node

func spawn_unit(unit: RUnit, unit_position: Vector2) -> void:
  var unit_position_offset := Vector2(0.5, 0.5)
  var unit_position_noise := Vector2(randf_range(0.25, 0.75), randf_range(0.25, 0.75))

  var unit_node := unit_scene.instantiate()
  unit_node.unit = unit
  unit_node.position = (unit_position + unit_position_offset + unit_position_noise) * Vector2(GameConfig.tile_size)
  prints('Spawn unit', unit.name, 'at', unit_node.position)
  unitsContainer.add_child(unit_node)
