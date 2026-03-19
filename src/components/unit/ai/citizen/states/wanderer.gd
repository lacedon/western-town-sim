extends "./abstract_state.gd";

const Thinker = preload("./thinker.gd")

## This state just makes the citizen wander around within a certain radius
## TODO: think how exit from the state

const max_tries_to_find_position: int = 10
const awaiting_time_in_seconds: float = 2.

func init() -> void:
  self._set_random_target_within_radius()

func target_reached() -> void:
  self.ai.set_state(Thinker.new().copy(self))

func _generate_random_target_position() -> Vector2:
  return self.node.position + Vector2(
    randf_range(-self.unit.wandering_radius, self.unit.wandering_radius),
    randf_range(-self.unit.wandering_radius, self.unit.wandering_radius)
  )

func _set_random_target_within_radius() -> void:
  for tries in range(max_tries_to_find_position):
    var random_position: Vector2 = self._generate_random_target_position()
    self.ai.set_target_position(random_position)
    return

  await self.node.get_tree().create_timer(awaiting_time_in_seconds).timeout
  self._set_random_target_within_radius()
