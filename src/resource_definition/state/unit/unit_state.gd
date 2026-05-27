extends Resource

class_name RUnitState

func _init(
  _unit: RUnit = self.unit,
  _unit_name: String = self.unit_name,
  building: RBuildingState = self.building
):
  self.unit = _unit
  self.unit_name = _unit_name
  self.building = _building

func clone():
  return RUnitState.new(self.unit, self.unit_name, self.building)

## unit object
@export var unit: RUnit
## Name of the exact unit. E.g. John
@export var unit_name: String = ""
## The building the unit is currently in. Null if unit is not in the building
@export var building: RBuildingState = null
