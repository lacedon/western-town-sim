extends BuildingFunction

class_name BuildingFunctionHouse

const person_capacity_resource = preload("res://assets/resources/town_resources/person_capacity.tres")

@export var capacity: int = 6

func on_building_placed(_building: RBuilding) -> void:
  StateController.economy_manager.update_max_resource(person_capacity_resource.name, capacity)

func on_building_destroyed(_building: RBuilding) -> void:
  StateController.economy_manager.update_max_resource(person_capacity_resource.name, -capacity)
