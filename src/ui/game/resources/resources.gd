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
  EventEmitter.add_listener(EventEmitter.event_name, updateResource)
  EventEmitter.add_listener(EventEmitter.event_name, updateMaxResource)

func _exit_tree() -> void:
  EventEmitter.remove_listener(EventEmitter.event_name, updateResource)
  EventEmitter.remove_listener(EventEmitter.event_name, updateMaxResource)

func updateResource(event_name: String, payload: Dictionary) -> void:
  if event_name != eventConstants.UPDATE_RESOURCE: return

  for resourceNode in resourceNodes:
    if resourceNode.resource.name == payload.resource_name:
      resourceNode.changeValue(payload.value_change)
      return

func updateMaxResource(event_name: String, payload: Dictionary) -> void:
  if event_name != eventConstants.UPDATE_RESOURCE_MAX: return

  for resourceNode in resourceNodes:
    if resourceNode.resource.name == payload.resource_name:
      resourceNode.changeMaxValue(payload.value_change)
      return
