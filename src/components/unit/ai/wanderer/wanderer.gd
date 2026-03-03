extends "../abstract/abstract-ai.gd"

const max_tries_to_find_position: int = 10
const awaiting_time_in_seconds: float = 2.

func init() -> void:
  _set_random_target_within_radius()

func _generate_random_target_position() -> Vector2:
  return node.position + Vector2(
    randf_range(-unit.wandering_radius, unit.wandering_radius),
    randf_range(-unit.wandering_radius, unit.wandering_radius)
  )

func _set_random_target_within_radius() -> void:
  for tries in range(max_tries_to_find_position):
    var random_position: Vector2 = _generate_random_target_position()
    is_moving = true
    self.target_changed.emit(random_position)
    return
  await get_tree().create_timer(awaiting_time_in_seconds).timeout
  _set_random_target_within_radius()

func target_reached() -> void:
  is_moving = false
  await get_tree().create_timer(awaiting_time_in_seconds).timeout
  _set_random_target_within_radius()
