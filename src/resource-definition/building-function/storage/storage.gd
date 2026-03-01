extends BuildingFunction

class_name BuildingFunctionStorage

const eventConstants = preload("res://src/constants/events.gd")

@export var resources: Array[StorageResourceDefinition] = []

func onBuildingPlaced(_building: RBuilding) -> void:
  for resourceDef in resources:
    EventEmitter.emit_event(eventConstants.UPDATE_RESOURCE_MAX, {
      resource_name = resourceDef.resource.name,
      value_change = resourceDef.maxCapacity
    })

func onBuildingDestroyed(_building: RBuilding) -> void:
  for resourceDef in resources:
    EventEmitter.emit_event(eventConstants.UPDATE_RESOURCE_MAX, {
      resource_name = resourceDef.resource.name,
      value_change = -resourceDef.maxCapacity
    })
