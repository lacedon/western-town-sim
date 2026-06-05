## This state walk the unit to a target

extends "./walker.gd";
class_name CitizenAIStateWorkAssigner

const CoordinateParser = preload("res://src/common/coordinate_parser.gd")

static func try_translate_to(current_state: AbstractCitizenState) -> AbstractCitizenState:
  var available_job: RJob = StateController.job_manager.get_available_job()
  if available_job:
    var new_state = CitizenAIStateWorkAssigner.new().copy(current_state)
    new_state.job = available_job
    return new_state
  return null

@export var job: RJob

func init() -> void:
  if self.job:
    StateController.job_manager.assign_job(self.job, self.unit_state)

    if self.job.building_state && self.job.building_state.building:
      self.target = CoordinateParser.game_tiles_center_to_pixels(
        self.job.building_state.building.get_entrance_position_gt(self.job.building_state)
      )

  super.init()

func target_reached() -> void:
  if (
    self.job.building_state.can_unit_enter(self.unit_state) &&
    self.unit_state.can_enter_building(self.job.building_state)
  ):
    self.unit_state.enter_building(self.job.building_state)
