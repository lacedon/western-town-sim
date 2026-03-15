extends BuildingFunction

class_name BuildingFunctionHouse

const personCapacityResource = preload("res://assets/resources/town_resources/person_capacity.tres")

@export var capacity: int = 6

func on_building_placed(_building: RBuilding) -> void:
  StateController.economy_manager.update_max_resource(personCapacityResource.name, capacity)

func on_building_destroyed(_building: RBuilding) -> void:
  StateController.economy_manager.update_max_resource(personCapacityResource.name, -capacity)
