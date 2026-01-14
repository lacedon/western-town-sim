extends BuildingFunction

class_name BuildingFunctionStorage

const eventConstants = preload("res://src/constants/events.gd")

signal update_resource_max(resourceName: String, value: int)

@export var resources: Array[StorageResourceDefinition] = []

func onBuildingPlaced(_building: RBuilding) -> void:
  # TODO: Rework with analog of _ready
  EventEmitter.addEmitter(eventConstants.UPDATE_RESOURCE_MAX, self)

  for resourceDef in resources:
    self.emit_signal(eventConstants.UPDATE_RESOURCE_MAX, resourceDef.resource.name, resourceDef.maxCapacity)

func onBuildingDestroyed(_building: RBuilding) -> void:
  # TODO: Rework with analog of _exit_tree
  EventEmitter.removeEmitter(eventConstants.UPDATE_RESOURCE_MAX, self)

  for resourceDef in resources:
    self.emit_signal(eventConstants.UPDATE_RESOURCE_MAX, resourceDef.resource.name, -resourceDef.maxCapacity)
