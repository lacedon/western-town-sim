extends BuildingFunction

class_name BuildingFunctionStorage

@export var resources: Array[StorageResourceDefinition] = []

func on_building_placed(_building: RBuilding) -> void:
  for resourceDef in resources:
    StateController.economy_manager.update_max_resource(resourceDef.resource.name, resourceDef.maxCapacity)

func on_building_destroyed(_building: RBuilding) -> void:
  for resourceDef in resources:
    StateController.economy_manager.update_max_resource(resourceDef.resource.name, -resourceDef.maxCapacity)
