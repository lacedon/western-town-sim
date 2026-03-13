extends Button

@export var building: RBuilding

func startBuilding():
  StateController.builder.start_building(building)
