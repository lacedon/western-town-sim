## This state run thinking process to select one of the others states
## depen on the requirements for this state

extends "./abstract_state.gd"

const CoordinateParser = preload("res://src/common/coordinate_parser.gd")

const awaiting_time_in_seconds: float = 1.

var possible_states_queue = [
  CitizenAIStateWorkAssigner,
  CitizenAIStateWanderer
]

func init() -> void:
  await self.node.get_tree().create_timer(awaiting_time_in_seconds).timeout

  for possible_state in possible_states_queue:
    var new_state = possible_state.try_translate_to(self)
    if new_state:
      self.ai.set_state(new_state)
      return
