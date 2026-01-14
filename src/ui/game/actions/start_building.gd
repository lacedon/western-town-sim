extends Button

const eventConstants = preload("res://src/constants/events.gd")

signal start_building(name: RBuilding)

@export var building: RBuilding

func _ready() -> void:
  EventEmitter.addEmitter(eventConstants.START_BUILDING, self)

func _exit_tree() -> void:
  EventEmitter.removeEmitter(eventConstants.START_BUILDING, self)

func startBuilding():
  self.emit_signal(start_building.get_name(), building)
