@icon("res://assets/icons/manager_service.svg")

extends Node

const AbstractBuilder = preload('res://src/managers/builder/builder.gd')
const AbstractDayTimer = preload('res://src/managers/day_timer/day_timer.gd')
const AbstractEconomyManager = preload('res://src/managers/economy_manager/economy_manager.gd')
const AbstractSpawner = preload('res://src/managers/spawner/spawner.gd')

@export var builder: AbstractBuilder
@export var day_timer: AbstractDayTimer
@export var economy_manager: AbstractEconomyManager
@export var spawner: AbstractSpawner

func _ready() -> void:
  StateController.set_builder(builder)
  StateController.set_day_timer(day_timer)
  StateController.set_economy_manager(economy_manager)
  StateController.set_spawner(spawner)
