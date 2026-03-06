@icon("res://assets/icons/navigator.svg")

extends Node2D

@abstract class AbstractNavigationServer:
  @abstract func add_environment_obstacle(obstacle_position: Vector2, obstacle_size: Vector2i) -> void
  @abstract func remove_environment_obstacle(obstacle_position: Vector2, obstacle_size: Vector2i) -> void
