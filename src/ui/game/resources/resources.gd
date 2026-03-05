extends Control

const eventConstants = preload("res://src/constants/events.gd")
const GameUIResource = preload("./resource.gd")

@onready var resourceFood: GameUIResource = $ResourceFood
@onready var resourceCapacity: GameUIResource = $ResourceCapacity

@onready var resourceNodes: Array[GameUIResource] = [
  resourceFood,
  resourceCapacity
]

func _ready() -> void:
  StateController.economy_manager.connect(StateController.economy_manager.resource_updated.get_name(), self.update_resource)
  StateController.economy_manager.connect(StateController.economy_manager.max_resource_updated.get_name(), self.update_max_resource)

func _exit_tree() -> void:
  StateController.economy_manager.disconnect(StateController.economy_manager.resource_updated.get_name(), self.update_resource)
  StateController.economy_manager.disconnect(StateController.economy_manager.max_resource_updated.get_name(), self.update_max_resource)

func update_resource(resource: TownResource, _diff: float) -> void:
  for resourceNode in resourceNodes:
    if resourceNode.resource.name == resource.name:
      resourceNode.set_value(floor(resource.value))
      return

func update_max_resource(resource: TownResource, _diff: float) -> void:
  for resourceNode in resourceNodes:
    if resourceNode.resource.name == resource.name:
      resourceNode.set_max_value(floor(resource.max_value))
      return
