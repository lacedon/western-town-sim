extends Node

const AbstractBuilder = preload("res://src/managers/builder/builder.gd")
const AbstractDayTimer = preload("res://src/managers/day_timer/day_timer.gd")
const AbstractEconomyManager = preload("res://src/managers/economy_manager/economy_manager.gd")
const AbstractJobManager = preload('res://src/managers/job_manager/job_manager.gd')
const AbstractNavigationServer = preload('res://src/managers/navigation_server/navigation_server.gd')
const AbstractSpawner = preload("res://src/managers/spawner/spawner.gd")
const AbstractNameGenerator = preload("res://src/managers/name_generator/name_generator.gd")

@export var builder: AbstractBuilder = null
@export var day_timer: AbstractDayTimer = null
@export var economy_manager: AbstractEconomyManager = null
@export var job_manager: AbstractJobManager = null
@export var name_generator: AbstractNameGenerator = null
@export var navigation_server: AbstractNavigationServer = null
@export var spawner: AbstractSpawner = null

func reset() -> void:
  builder = null
  day_timer = null
  economy_manager = null
  job_manager = null
  name_generator = null
  navigation_server = null
  spawner = null

func set_builder(new_builder: AbstractBuilder) -> void:
  self.builder = new_builder

func set_day_timer(new_day_timer: AbstractDayTimer) -> void:
  self.day_timer = new_day_timer

func set_economy_manager(new_economy_manager: AbstractEconomyManager) -> void:
  self.economy_manager = new_economy_manager

func set_job_manager(new_job_manager: AbstractJobManager) -> void:
  self.job_manager = new_job_manager

func set_navigation_server(new_navigation_server: AbstractNavigationServer) -> void:
  self.navigation_server = new_navigation_server

func set_name_generator(new_name_generator: AbstractNameGenerator) -> void:
  self.name_generator = new_name_generator

func set_spawner(new_spawner: AbstractSpawner) -> void:
  self.spawner = new_spawner
