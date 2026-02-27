extends BuildingFunction

class_name BuildingFunctionSpawner

@export var unit: RUnit

func onDayChange(building: RBuilding) -> void:
  prints('Spawn', unit, building.entrances)
