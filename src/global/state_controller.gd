extends Node

const AbstractBuilder = preload("res://src/managers/builder/builder.gd")
const AbstractDayTimer = preload("res://src/managers/day_timer/day_timer.gd")
const AbstractEconomyManager = preload("res://src/managers/economy_manager/economy_manager.gd")
const AbstractSpawner = preload("res://src/managers/spawner/spawner.gd")

@export var builder: AbstractBuilder = null
@export var day_timer: AbstractDayTimer = null
@export var economy_manager: AbstractEconomyManager = null
@export var spawner: AbstractSpawner = null

func reset() -> void:
  builder = null
  day_timer = null
  economy_manager = null
  spawner = null

func set_builder(new_builder: AbstractBuilder) -> void:
  self.builder = new_builder

func set_day_timer(new_day_timer: AbstractDayTimer) -> void:
  self.day_timer = new_day_timer

func set_economy_manager(new_economy_manager: AbstractEconomyManager) -> void:
  self.economy_manager = new_economy_manager

func set_spawner(new_spawner: AbstractSpawner) -> void:
  self.spawner = new_spawner
