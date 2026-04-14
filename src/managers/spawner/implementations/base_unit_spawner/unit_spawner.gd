class_name UnitSpawner
extends "../../spawner.gd"

const unit_scene = preload("res://src/components/unit/unit.tscn")
const CoordinateParser = preload("res://src/common/coordinate_parser.gd")

@export var units_container: Node

func spawn_unit(unit: RUnit, unit_position_gt: Vector2) -> void:
  var unit_position_noise_gt := Vector2(randf_range(0.25, 0.75), randf_range(0.25, 0.75))

  var unit_node := unit_scene.instantiate()
  unit_node.unit = unit
  unit_node.position = CoordinateParser.game_tiles_center_to_pixels(unit_position_gt) + unit_position_noise_gt
  units_container.add_child(unit_node)
