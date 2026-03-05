extends Button

const eventConstants = preload("res://src/constants/events.gd")

@export var building: RBuilding

func startBuilding():
  StateController.builder.start_building(building)
