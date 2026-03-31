extends Control

const GameUIResource = preload("./resource.gd")

@onready var resource_food: GameUIResource = $ResourceFood
@onready var resource_capacity: GameUIResource = $ResourceCapacity

@onready var resource_nodes: Array[GameUIResource] = [
  resource_food,
  resource_capacity
]

func _ready() -> void:
  StateController.economy_manager.connect(StateController.economy_manager.resource_updated.get_name(), self.update_resource)
  StateController.economy_manager.connect(StateController.economy_manager.max_resource_updated.get_name(), self.update_max_resource)

func _exit_tree() -> void:
  StateController.economy_manager.disconnect(StateController.economy_manager.resource_updated.get_name(), self.update_resource)
  StateController.economy_manager.disconnect(StateController.economy_manager.max_resource_updated.get_name(), self.update_max_resource)

func update_resource(resource: TownResource, _diff: float) -> void:
  for resource_node in resource_nodes:
    if resource_node.resource.name == resource.name:
      resource_node.set_value(floor(resource.value))
      return

func update_max_resource(resource: TownResource, _diff: float) -> void:
  for resource_node in resource_nodes:
    if resource_node.resource.name == resource.name:
      resource_node.set_max_value(floor(resource.max_value))
      return
