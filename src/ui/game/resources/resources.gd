extends Control

const eventConstants = preload("res://src/constants/events.gd")
const GameUIResource = preload("./resource.gd")

@onready var resourceFood: GameUIResource = $ResourceFood
@onready var resourceCapacity: GameUIResource = $ResourceCapacity

func _ready() -> void:
  EventEmitter.addListener(eventConstants.UPDATE_RESOURCE, updateResource)

func _exit_tree() -> void:
  EventEmitter.removeListener(eventConstants.UPDATE_RESOURCE, updateResource)

func updateResource(resourceName: String, value: int) -> void:
  ## TODO: Rework it not to work with magic strings
  match resourceName:
    'food': resourceFood.updateValue(value)
    'capacity': resourceCapacity.updateValue(value)

func updateMaxResource(resourceName: String, maxValue: int) -> void:
  ## TODO: Rework it not to work with magic strings
  match resourceName:
    'food': resourceFood.updateMaxValue(maxValue)
    'capacity': resourceCapacity.updateMaxValue(maxValue)
