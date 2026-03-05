@icon("res://assets/icons/manager.svg")

extends Node

@abstract class AbstractBuilder:
  @abstract func start_building(building: RBuilding) -> void
  @abstract func stop_building() -> void
