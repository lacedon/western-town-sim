extends Resource

class_name RUnitState

signal entered_in_building
signal exited_from_building

func _init(
  _unit: RUnit = self.unit,
  _name: String = self.name,
  _building: RBuildingState = self.building
):
  self.unit = _unit
  self.name = _name
  self.building = _building

func clone():
  return RUnitState.new(self.unit, self.name, self.building)

func can_enter_building(_building_state: RBuildingState) -> bool:
  return self.building == null

func can_exit_building() -> bool:
  return true

func enter_building(building_state: RBuildingState) -> void:
  self.building = building_state
  building_state.unit_enter(self)
  self.entered_in_building.emit()

func exit_building(_is_silently: bool) -> void:
  if self.building:
    self.building.unit_exit(self)
  self.building = null
  self.exited_from_building.emit()

## unit object
@export var unit: RUnit
## Name of the exact unit. E.g. John
@export var name: String = ""
## The building the unit is currently in. Null if unit is not in the building
@export var building: RBuildingState = null
## Reference to the unit's AI node, set by UnitNode when the unit is created.
## Not persisted — lets game logic command the unit's AI directly (e.g. send it on an errand)
var ai_agent: Node = null
