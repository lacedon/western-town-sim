extends BuildingFunction

class_name BuildingFunctionSpawner

const events = preload("res://src/constants/events.gd")
const random_helper = preload("res://src/common/random.gd")

@export var unit: RUnit

func onDayChange(building: RBuilding, position: Vector2) -> void:
  var entrance = random_helper.get_random_element(building.entrances)
  var unit_position: Vector2 = entrance + position if entrance else position

  EventEmitter.emit_event(events.SPAWN_UNIT, {
    unit = unit,
    unit_position = unit_position
  })
