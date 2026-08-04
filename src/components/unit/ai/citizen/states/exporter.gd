## This state walks a worker to the nearest storage building to deliver a batch of
## resources produced at their workplace, then walks back and resumes work there.
## Unlike the other states this is never picked by Thinker's polling — it is
## dispatched directly onto a specific worker's AI (see `dispatch`)

extends "./walker.gd"
class_name CitizenAIStateExporter

const CoordinateParser = preload("res://src/common/coordinate_parser.gd")

enum Phase {
  to_storage,
  returning,
}

@export var phase: Phase = Phase.to_storage
@export var source_building_state: RBuildingState
@export var storage_node: BuildingNode
@export var resource: TownResource
@export var amount: int = 0

## Finds the closest placed building that provides storage, or null if none exist
static func find_nearest_storage(from_node: Node2D) -> BuildingNode:
  var nearest: BuildingNode = null
  var nearest_distance: float = INF

  for candidate in from_node.get_tree().get_nodes_in_group(&"storage_buildings"):
    var distance: float = from_node.global_position.distance_squared_to(candidate.global_position)
    if distance < nearest_distance:
      nearest_distance = distance
      nearest = candidate

  return nearest

## Interrupts the given citizen's current AI state to send them on a delivery errand
static func dispatch(
  citizen_ai: CitizenAI,
  building_state: RBuildingState,
  storage_building_node: BuildingNode,
  resource_to_deliver: TownResource,
  resource_amount: int
) -> void:
  var new_state: CitizenAIStateExporter = CitizenAIStateExporter.new()
  new_state.define(citizen_ai.unit, citizen_ai.unit_state, citizen_ai.node, citizen_ai)
  new_state.source_building_state = building_state
  new_state.storage_node = storage_building_node
  new_state.resource = resource_to_deliver
  new_state.amount = resource_amount
  citizen_ai.set_state(new_state)

func init() -> void:
  self.unit_state.exit_building(true)

  self.phase = Phase.to_storage
  self.target = CoordinateParser.game_tiles_center_to_pixels(
    storage_node.building.get_entrance_position_gt(storage_node.building_state)
  )
  super.init()

func target_reached() -> void:
  match phase:
    Phase.to_storage:
      StateController.economy_manager.update_resource(resource.name, amount)
      phase = Phase.returning
      self.target = CoordinateParser.game_tiles_center_to_pixels(
        source_building_state.building.get_entrance_position_gt(source_building_state)
      )
      self.ai.set_target_position(self.target)
    Phase.returning:
      if source_building_state.can_unit_enter(unit_state) && unit_state.can_enter_building(source_building_state):
        unit_state.enter_building(source_building_state)
      source_building_state.is_exporting[resource.name] = false
      self.ai.set_state(Thinker.new().copy(self))
