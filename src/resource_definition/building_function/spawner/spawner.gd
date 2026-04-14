extends BuildingFunction

class_name BuildingFunctionSpawner

const random_helper = preload("res://src/common/random.gd")
const person_capacity_resource = preload("res://assets/resources/town_resources/person_capacity.tres")

@export var unit: RUnit
@export var unit_capacity_size: int = 1

var new_unit_resource: TownResource = person_capacity_resource.get_copy_with_value(unit_capacity_size)

func on_day_change(building: RBuilding) -> void:
  var is_resource_used: bool = StateController.economy_manager.use_resource(new_unit_resource)

  if !is_resource_used:
    return

  var entrance_gt: Vector2 = random_helper.get_random_element(building.entrances)
  var unit_position_gt: Vector2 = entrance_gt + building.position_gt if entrance_gt else building.position_gt
  var building_top_left_corner_gt: Vector2 = building.position_gt - Vector2(round(float(building.size.x) / 2), round(float(building.size.y) / 2))

  StateController.spawner.spawn_unit(unit, unit_position_gt - building_top_left_corner_gt)
