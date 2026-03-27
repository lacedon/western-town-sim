## This state just makes the unit wander around within a certain radius

extends "./walker.gd";
class_name CitizenAIStateWanderer

static func try_translate_to(current_state: AbstractCitizenState) -> AbstractCitizenState:
  return CitizenAIStateWanderer.new().copy(current_state)

const max_tries_to_find_position: int = 10
const awaiting_time_in_seconds: float = 2.

func init() -> void:
  self.target = _generate_random_target_position()
  super.init()

func target_reached() -> void:
  self.ai.set_state(Thinker.new().copy(self))

func _generate_random_target_position() -> Vector2:
  return self.node.position + Vector2(
    randf_range(-self.unit.wandering_radius, self.unit.wandering_radius),
    randf_range(-self.unit.wandering_radius, self.unit.wandering_radius)
  )
