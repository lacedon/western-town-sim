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
  GameResourceManager.connect(GameResourceManager.resource_updated.get_name(), self.update_resource)
  GameResourceManager.connect(GameResourceManager.max_resource_updated.get_name(), self.update_max_resource)

func _exit_tree() -> void:
  GameResourceManager.disconnect(GameResourceManager.resource_updated.get_name(), self.update_resource)
  GameResourceManager.disconnect(GameResourceManager.max_resource_updated.get_name(), self.update_max_resource)

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
