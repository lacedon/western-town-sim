extends Control

const eventConstants = preload("res://src/constants/events.gd")
const GameUIResource = preload("./resource.gd")

@onready var resourceFood: GameUIResource = $ResourceFood
@onready var resourceCapacity: GameUIResource = $ResourceCapacity

func _ready() -> void:
  EventEmitter.addListener(eventConstants.UPDATE_RESOURCE, updateResource)
  EventEmitter.addListener(eventConstants.UPDATE_RESOURCE_MAX, updateMaxResource)

func _exit_tree() -> void:
  EventEmitter.removeListener(eventConstants.UPDATE_RESOURCE, updateResource)
  EventEmitter.removeListener(eventConstants.UPDATE_RESOURCE_MAX, updateMaxResource)

func updateResource(resourceName: String, value: int) -> void:
  ## TODO: Rework it not to work with magic strings
  match resourceName:
    'food': resourceFood.changeValue(value)
    'capacity': resourceCapacity.changeValue(value)

func updateMaxResource(resourceName: String, maxValue: int) -> void:
  ## TODO: Rework it not to work with magic strings
  match resourceName:
    'food': resourceFood.changeMaxValue(maxValue)
    'capacity': resourceCapacity.changeMaxValue(maxValue)
