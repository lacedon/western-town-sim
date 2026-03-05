class_name DayTimer
extends "../../day-timer.gd"

@onready var timer: Timer = $Timer

func _ready():
  timer.wait_time = GameConfig.day_length_seconds
  timer.start()

func emit_start_of_day() -> void:
  start_of_day.emit()
