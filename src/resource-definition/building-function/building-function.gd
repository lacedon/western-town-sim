extends Resource

## Describes buildings functions
class_name BuildingFunction

@export var name: String
@export_multiline var description: String

## Called when building is placed in the world
func onBuildingPlaced(_building: RBuilding) -> void:
  pass

## Called when building is destroyed. Can be used to cleanup resources or other things
func onBuildingDestroyed(_building: RBuilding) -> void:
  pass

func on_day_change(_building: RBuilding, _position: Vector2) -> void:
  pass
