extends BuildingFunction

class_name BuildingFunctionSpawner

const person_capacity_resource = preload("res://assets/resources/town_resources/person_capacity.tres")

@export var unit: RUnit
@export var unit_capacity_size: int = 1

var new_unit_resource: TownResource = person_capacity_resource.get_copy_with_value(unit_capacity_size)

func on_day_change(building: RBuilding, building_state: RBuildingState) -> void:
  var is_resource_used: bool = StateController.economy_manager.use_resource(new_unit_resource)

  if !is_resource_used:
    return

  var entrance_gt: Vector2 = building.entrances.pick_random()
  var unit_position_gt: Vector2 = building_state.position_gt + (entrance_gt if entrance_gt else Vector2.ZERO)

  StateController.spawner.spawn_unit(unit, unit_position_gt)
