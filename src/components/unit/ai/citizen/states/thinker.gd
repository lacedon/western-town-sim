## This state run thinking process to select one of the others states
## depen on the requirements for this state

extends "./abstract_state.gd"

const CoordinateParser = preload("res://src/common/coordinate_parser.gd")
const Wanderer = preload("./wanderer.gd")
const Walker = preload("./walker.gd")

const awaiting_time_in_seconds: float = 1.

var _try_state_actions: Array[Callable] = [
  self._check_job_state
]
var set_default_state: Callable = self._change_status_to_wanderer

func init() -> void:
  await self.node.get_tree().create_timer(awaiting_time_in_seconds).timeout

  for _try_state_action in _try_state_actions:
    var is_state_enabled = _try_state_action.call()
    if is_state_enabled: return

  set_default_state.call()

## TODO: would be nice not to have all this logic here
## Think if can move it to the specific classes and work there
## Maybe create class walkerToWork with transition and condition logic there
func _check_job_state() -> bool:
  var available_job: RJob = StateController.job_manager.get_available_job()
  if !available_job: return false

  StateController.job_manager.assign_job(available_job, self.unit)
  var next_state := Walker.new().copy(self)
  next_state.target = CoordinateParser.game_tiles_center_to_pixels(available_job.building.get_entrance_position_gt())
  self.ai.set_state(next_state)

  return true

func _change_status_to_wanderer() -> void:
  self.ai.set_state(Wanderer.new().copy(self))
