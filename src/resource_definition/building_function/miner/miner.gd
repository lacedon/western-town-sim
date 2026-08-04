extends BuildingFunction

class_name BuildingFunctionMiner

@export var resources: Array[MinerResourceDefinition] = []
@export var min_workers_to_mine: int = 1
@export var max_workers_to_mine: int = 5

func on_building_placed(building_state: RBuildingState) -> void:
  for index in range(max_workers_to_mine):
    var job = RBuildingJob.new()
    job.name = "Work #" + str(index + 1) + " on " + building_state.building.name
    job.building_state = building_state
    job.type = RJob.JobTypes.Recurring
    StateController.job_manager.add_job(job)

## Generation speed scales linearly with the number of workers currently inside,
## reaching 100% (one resource every `seconds_to_generate` seconds) at `max_workers_to_mine`.
## Produced units accumulate in local storage; once `min_count_for_export` is reached,
## a worker carries the batch out to the nearest storage building
func on_process(building_state: RBuildingState, delta: float) -> void:
  var worker_count: int = building_state.units_inside_workers.size()

  for resource_def in resources:
    if worker_count >= min_workers_to_mine:
      var speed: float = clampf(float(worker_count) / float(max_workers_to_mine), 0.0, 1.0)
      _produce(building_state, resource_def, delta * speed)

    _try_export(building_state, resource_def)

func _produce(building_state: RBuildingState, resource_def: MinerResourceDefinition, time_produced: float) -> void:
  var town_resource_name: String = resource_def.resource.name
  var stored: int = building_state.stored_resources.get(town_resource_name, 0)
  if resource_def.max_capacity_to_store >= 0 && stored >= resource_def.max_capacity_to_store:
    return

  var progress: float = building_state.production_progress.get(town_resource_name, 0.0) + time_produced
  while progress >= resource_def.seconds_to_generate && (resource_def.max_capacity_to_store < 0 || stored < resource_def.max_capacity_to_store):
    progress -= resource_def.seconds_to_generate
    stored += 1

  building_state.production_progress[town_resource_name] = progress
  building_state.stored_resources[town_resource_name] = stored

func _try_export(building_state: RBuildingState, resource_def: MinerResourceDefinition) -> void:
  var town_resource_name: String = resource_def.resource.name
  var stored: int = building_state.stored_resources.get(town_resource_name, 0)

  if stored < resource_def.min_count_for_export: return
  if building_state.is_exporting.get(town_resource_name, false): return
  if building_state.units_inside_workers.is_empty(): return
  if !StateController.economy_manager.has_room_for_resource(town_resource_name, resource_def.min_count_for_export): return

  var worker: RUnitState = building_state.units_inside_workers[0]
  var citizen_ai: CitizenAI = worker.ai_agent as CitizenAI
  if !citizen_ai: return

  var storage_node: BuildingNode = CitizenAIStateExporter.find_nearest_storage(citizen_ai.node)
  if !storage_node: return

  building_state.stored_resources[town_resource_name] = stored - resource_def.min_count_for_export
  building_state.is_exporting[town_resource_name] = true

  CitizenAIStateExporter.dispatch(citizen_ai, building_state, storage_node, resource_def.resource, resource_def.min_count_for_export)
