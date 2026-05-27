extends Resource

class_name RUnitState

func _init(
  _unit_rid: RID = self.unit_rid,
  _unit_name: String = self.unit_name,
  building: RBuildingState = self.building
):
  self.unit_rid = _unit_rid
  self.unit_name = _unit_name
  self.building = _building

func clone():
  return RUnitState.new(self.unit_rid, self.unit_name, self.building)

## RID of the unit scene just for reference
@export var unit_rid: RID
## Name of the exact unit. E.g. John
@export var unit_name: String = ""
## The building the unit is currently in. Null if unit is not in the building
@export var building: RBuildingState = null
