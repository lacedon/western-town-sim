@icon("res://assets/icons/manager.svg")

extends Node

@warning_ignore('UNUSED_SIGNAL')
signal resource_updated(resource: TownResource, value_change: float)

@warning_ignore('UNUSED_SIGNAL')
signal max_resource_updated(resource: TownResource, value_change: float)

@abstract class AbstractEconomyManager:
  @abstract func update_resource(resource_name: String, value_change: float) -> void
  @abstract func update_max_resource(resource_name: String, value_change: float) -> void
  @abstract func has_enough_resources(required_resources: Array[TownResource]) -> bool
  @abstract func use_resources(required_resources: Array[TownResource]) -> bool
