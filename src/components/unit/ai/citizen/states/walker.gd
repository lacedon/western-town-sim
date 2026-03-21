## This state walk the unit to a target

extends "./abstract_state.gd";

const Thinker = preload("./thinker.gd")

@export var target: Vector2

func init() -> void:
  if self.target:
    self.ai.set_target_position(self.target)
  else:
    self.ai.set_state(Thinker.new().copy(self))

func target_reached() -> void:
  # TODO: Right now this state is used to go to work. Need to transit to work state once the target is reached
  pass
