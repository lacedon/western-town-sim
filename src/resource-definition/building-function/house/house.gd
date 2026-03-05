extends BuildingFunction

class_name BuildingFunctionHouse

const eventConstants = preload("res://src/constants/events.gd")
const personCapacityResource = preload("res://assets/resources/town-resources/person-capacity.tres")

@export var capacity: int = 6

func onBuildingPlaced(_building: RBuilding) -> void:
  StateController.economy_manager.update_max_resource(personCapacityResource.name, capacity)

func onBuildingDestroyed(_building: RBuilding) -> void:
  StateController.economy_manager.update_max_resource(personCapacityResource.name, -capacity)
