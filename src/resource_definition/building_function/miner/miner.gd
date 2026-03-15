extends BuildingFunction

class_name BuildingFunctionMiner

@export var resources: Array[MinerResourceDefinition] = []
@export var minWorkersToMine: int = 1
@export var maxWorkersToMine: int = 5

func on_building_placed(building: RBuilding) -> void:
  for index in range(maxWorkersToMine):
    var job = RJob.new()
    job.name = "Work #" + str(index + 1) + " on " + building.name
    StateController.job_manager.add_job(job)
