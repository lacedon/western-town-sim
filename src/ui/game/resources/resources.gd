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
  EventEmitter.addListener(eventConstants.UPDATE_RESOURCE, updateResource)
  EventEmitter.addListener(eventConstants.UPDATE_RESOURCE_MAX, updateMaxResource)

func _exit_tree() -> void:
  EventEmitter.removeListener(eventConstants.UPDATE_RESOURCE, updateResource)
  EventEmitter.removeListener(eventConstants.UPDATE_RESOURCE_MAX, updateMaxResource)

func updateResource(resourceName: String, value: int) -> void:
  for resourceNode in resourceNodes:
    if resourceNode.resource.name == resourceName:
      resourceNode.changeValue(value)
      return

func updateMaxResource(resourceName: String, maxValue: int) -> void:
  for resourceNode in resourceNodes:
    if resourceNode.resource.name == resourceName:
      resourceNode.changeMaxValue(maxValue)
      return
