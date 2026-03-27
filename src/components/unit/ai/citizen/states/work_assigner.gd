## This state walk the unit to a target

extends "./walker.gd";
class_name CitizenAIStateWorkAssigner

const CoordinateParser = preload("res://src/common/coordinate_parser.gd")

static func try_translate_to(current_state: AbstractCitizenState) -> AbstractCitizenState:
  var available_job: RJob = StateController.job_manager.get_available_job()
  prints('available_job', available_job)
  if available_job:
    var new_state = CitizenAIStateWorkAssigner.new().copy(current_state)
    new_state.job = available_job
    return new_state
  return null

@export var job: RJob

func init() -> void:
  if self.job:
    prints('job', self.job)
    StateController.job_manager.assign_job(self.job, self.unit)

    if self.job.building:
      prints('job building', self.job.building)
      self.target = CoordinateParser.game_tiles_center_to_pixels(self.job.building.get_entrance_position_gt())
      prints('target', self.target)

  super.init()

func target_reached() -> void:
  # TODO: Right now this state is used to go to work. Need to transit to work state once the target is reached
  pass
