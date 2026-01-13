extends BuildingFunction

class_name BuildingFunctionStorage

const eventConstants = preload("res://src/constants/events.gd")

signal update_resource_max(resourceName: String, value: int)

@export var resources: Array[StorageResourceDefinition] = []

func _ready() -> void:
  EventEmitter.addEmitter(eventConstants.START_BUILDING, self)

func _exit_tree() -> void:
  EventEmitter.removeEmitter(eventConstants.START_BUILDING, self)

func onBuildingPlaced(_building: RBuilding) -> void:
  for resourceDef in resources:
    self.emit_signal(eventConstants.UPDATE_RESOURCE_MAX, resourceDef.resourceName, resourceDef.maxCapacity)

func onBuildingDestroyed(_building: RBuilding) -> void:
  for resourceDef in resources:
    self.emit_signal(eventConstants.UPDATE_RESOURCE_MAX, resourceDef.resourceName, -resourceDef.maxCapacity)
