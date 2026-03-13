extends BuildingFunction

class_name BuildingFunctionStorage

@export var resources: Array[StorageResourceDefinition] = []

func onBuildingPlaced(_building: RBuilding) -> void:
  for resourceDef in resources:
    StateController.economy_manager.update_max_resource(resourceDef.resource.name, resourceDef.maxCapacity)

func onBuildingDestroyed(_building: RBuilding) -> void:
  for resourceDef in resources:
    StateController.economy_manager.update_max_resource(resourceDef.resource.name, -resourceDef.maxCapacity)
