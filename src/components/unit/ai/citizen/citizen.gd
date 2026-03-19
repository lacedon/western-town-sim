extends "../abstract/abstract_ai.gd"
class_name CitizenAI

const AbstractCitizenState = preload("./states/abstract_state.gd")
const Thinker = preload("./states/thinker.gd")

var state: AbstractCitizenState

func init() -> void:
  set_state(Thinker.new().define(self.unit, self.node, self))

func set_state(new_state: AbstractCitizenState) -> void:
  if self.state: self.state.stop()
  self.state = new_state
  self.state.init()

func _handle_target_reached():
  if self.state: self.state.target_reached()
