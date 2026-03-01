extends BuildingFunction

class_name BuildingFunctionHouse

const eventConstants = preload("res://src/constants/events.gd")
const personCapacityResource = preload("res://resources/resources/town-resources/person-capacity.tres")

@export var capacity: int = 6

func onBuildingPlaced(_building: RBuilding) -> void:
  EventEmitter.emit_event(eventConstants.UPDATE_RESOURCE_MAX, {
    resource_name = personCapacityResource.name,
    value_change = capacity
  })

func onBuildingDestroyed(_building: RBuilding) -> void:
  EventEmitter.emit_event(eventConstants.UPDATE_RESOURCE_MAX, {
    resource_name = personCapacityResource.name,
    value_change = -capacity
  })
