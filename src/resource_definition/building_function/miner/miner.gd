extends BuildingFunction

class_name BuildingFunctionMiner

@export var resources: Array[MinerResourceDefinition] = []
@export var min_workers_to_mine: int = 1
@export var max_workers_to_mine: int = 5

func on_building_placed(building: RBuilding, building_state: RBuildingState) -> void:
  for index in range(max_workers_to_mine):
    var job = RBuildingJob.new()
    job.name = "Work #" + str(index + 1) + " on " + building.name
    job.building = building
    job.building_state = building_state
    job.type = RJob.JobTypes.Recurring
    StateController.job_manager.add_job(job)
