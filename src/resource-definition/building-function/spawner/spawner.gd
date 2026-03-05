extends BuildingFunction

class_name BuildingFunctionSpawner

const events = preload("res://src/constants/events.gd")
const random_helper = preload("res://src/common/random.gd")
const person_capacity_resource = preload("res://assets/resources/town-resources/person-capacity.tres")

@export var unit: RUnit
@export var unit_capacity_size: int = 1

var new_unit_resource: TownResource = person_capacity_resource.get_copy_with_value(unit_capacity_size)

func on_day_change(building: RBuilding, position: Vector2) -> void:
  var is_resource_used: bool = StateController.economy_manager.use_resource(new_unit_resource)

  if !is_resource_used:
    return

  var entrance: Vector2 = random_helper.get_random_element(building.entrances)
  var unit_position: Vector2 = entrance + position if entrance else position

  StateController.spawner.spawn_unit(unit, unit_position)
