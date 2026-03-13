@icon("res://assets/icons/manager_service.svg")

extends Node

const AbstractBuilder = preload('res://src/managers/builder/builder.gd')
const AbstractDayTimer = preload('res://src/managers/day_timer/day_timer.gd')
const AbstractEconomyManager = preload('res://src/managers/economy_manager/economy_manager.gd')
const AbstractJobManager = preload('res://src/managers/job_manager/job_manager.gd')
const AbstractNavigationServer = preload('res://src/managers/navigation_server/navigation_server.gd')
const AbstractSpawner = preload('res://src/managers/spawner/spawner.gd')

@export var builder: AbstractBuilder
@export var day_timer: AbstractDayTimer
@export var economy_manager: AbstractEconomyManager
@export var job_manager: AbstractJobManager
@export var navigation_server: AbstractNavigationServer
@export var spawner: AbstractSpawner

func _ready() -> void:
  StateController.set_builder(builder)
  StateController.set_day_timer(day_timer)
  StateController.set_economy_manager(economy_manager)
  StateController.set_job_manager(job_manager)
  StateController.set_navigation_server(navigation_server)
  StateController.set_spawner(spawner)
