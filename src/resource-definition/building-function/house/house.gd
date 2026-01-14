extends BuildingFunction

class_name BuildingFunctionHouse

const eventConstants = preload("res://src/constants/events.gd")
const personCapacityResource = preload("res://resources/resources/town-resources/person-capacity.tres")

signal update_resource_max(resourceName: String, value: int)

@export var capacity: int = 6

func onBuildingPlaced(_building: RBuilding) -> void:
  # TODO: Rework with analog of _ready
  EventEmitter.addEmitter(eventConstants.UPDATE_RESOURCE_MAX, self)

  self.emit_signal(eventConstants.UPDATE_RESOURCE_MAX, personCapacityResource.name, capacity)

func onBuildingDestroyed(_building: RBuilding) -> void:
  self.emit_signal(eventConstants.UPDATE_RESOURCE_MAX, personCapacityResource.name, -capacity)

  # TODO: Rework with analog of _exit_tree
  EventEmitter.removeEmitter(eventConstants.UPDATE_RESOURCE_MAX, self)
