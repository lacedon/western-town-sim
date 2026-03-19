extends "./abstract_state.gd"

const Wanderer = preload("./wanderer.gd")

const awaiting_time_in_seconds: float = 1.

func init() -> void:
  await self.node.get_tree().create_timer(awaiting_time_in_seconds).timeout
  _change_status_to_wanderer()

func _change_status_to_wanderer() -> void:
  self.ai.set_state(Wanderer.new().copy(self))
