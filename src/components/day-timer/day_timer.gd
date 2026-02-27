extends Node2D

class_name DayTimer

signal start_of_day

const events = preload("res://src/constants/events.gd")

@onready var timer: Timer = $Timer

func _ready():
  timer.wait_time = GameConfig.day_length_seconds
  timer.start()

  EventEmitter.addEmitter(events.START_OF_DAY, self)

func _exit_tree() -> void:
  EventEmitter.removeEmitter(events.START_OF_DAY, self)

func emit_start_of_day() -> void:
  emit_signal(events.START_OF_DAY)
