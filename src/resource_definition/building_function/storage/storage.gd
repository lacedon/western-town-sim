extends BuildingFunction

class_name BuildingFunctionStorage

@export var resources: Array[StorageResourceDefinition] = []

func on_building_placed(_building: RBuilding, _building_state: RBuildingState) -> void:
  for resource_def in resources:
    StateController.economy_manager.update_max_resource(resource_def.resource.name, resource_def.max_capacity)

func on_building_destroyed(_building: RBuilding, _building_state: RBuildingState) -> void:
  for resource_def in resources:
    StateController.economy_manager.update_max_resource(resource_def.resource.name, -resource_def.max_capacity)
