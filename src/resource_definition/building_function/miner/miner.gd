extends BuildingFunction

class_name BuildingFunctionMiner

@export var resources: Array[MinerResourceDefinition] = []
@export var minWorkersToMine: int = 1
@export var maxWorkersToMine: int = 5

func on_building_placed(building: RBuilding) -> void:
  for index in range(maxWorkersToMine):
    var job = RBuildingJob.new()
    job.name = "Work #" + str(index + 1) + " on " + building.name
    job.building = building
    job.type = RJob.JobTypes.Recurring
    StateController.job_manager.add_job(job)
