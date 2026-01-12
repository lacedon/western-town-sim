extends Control

const eventConstants = preload("res://src/constants/events.gd")

const buildingFarm = preload("res://resources/resources/buildings/farm.tres")
const buildingFoodStorage = preload("res://resources/resources/buildings/food-storage.tres")

signal start_building(name: RBuilding)

func _ready() -> void:
  EventEmitter.addEmitter(eventConstants.START_BUILDING, self)

func _exit_tree() -> void:
  EventEmitter.removeEmitter(eventConstants.START_BUILDING, self)

func startBuildingFarm():
  self.emit_signal(start_building.get_name(), buildingFarm)

func startBuildingFoodStorage():
  self.emit_signal(start_building.get_name(), buildingFoodStorage)
