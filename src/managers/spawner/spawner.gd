@icon("res://assets/icons/manager.svg")

extends Node

@abstract class AbstractSpawner:
  @abstract func spawn_unit(unit: RUnit, unit_position: Vector2) -> void
