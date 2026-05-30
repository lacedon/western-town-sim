extends Resource

## Describes buildings functions
class_name BuildingFunction

@export var name: String
@export_multiline var description: String

## Called when building is placed in the world
func on_building_placed(_building_state: RBuildingState) -> void:
  pass

## Called when building is destroyed. Can be used to cleanup resources or other things
func on_building_destroyed(_building_state: RBuildingState) -> void:
  pass

func on_day_change(_building_state: RBuildingState) -> void:
  pass
