extends Node2D

## Used to spawn units in the game
## Can be done via event emitter events
class_name Spawner

const events = preload("res://src/constants/events.gd")
const unit_scene = preload("res://src/components/unit/unit.tscn")

func _ready() -> void:
  EventEmitter.add_listener(EventEmitter.event_name, self._handle_spawn_unit_event)

func _exit_tree() -> void:
  EventEmitter.remove_listener(EventEmitter.event_name, self._handle_spawn_unit_event)

func _handle_spawn_unit_event(event_name: String, data: Dictionary) -> void:
  if event_name != events.SPAWN_UNIT:
    return

  var unit: RUnit = data.unit
  var unit_position: Vector2 = data.unit_position
  spawn_unit(unit, unit_position)

func spawn_unit(unit: RUnit, unit_position: Vector2) -> void:
  var unit_position_offset := Vector2(0.5, 0.5)
  var unit_position_noise := Vector2(randf_range(0.25, 0.75), randf_range(0.25, 0.75))

  var unit_node := unit_scene.instantiate()
  unit_node.unit = unit
  unit_node.position = (unit_position + unit_position_offset + unit_position_noise) * Vector2(GameConfig.tile_size)
  prints('Spawn unit', unit.name, 'at', unit_node.position)
  add_child(unit_node)
