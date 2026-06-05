extends Resource

class_name RBuildingState

signal units_inside_changed

func _init(
  _building: RBuilding = self.building,
  _position_gt: Vector2 = self.position_gt,
  _units_inside_workers: Array[RUnitState] = self.units_inside_workers
):
  self.building = _building
  self.position_gt = _position_gt
  self.units_inside_workers = _units_inside_workers

func clone():
  return RBuildingState.new(self.building, self.position_gt, self.units_inside_workers)

func can_unit_enter(unit: RUnitState) -> bool:
  return unit not in self.units_inside_workers

func can_unit_exit(unit: RUnitState) -> bool:
  return unit in self.units_inside_workers

func unit_enter(unit: RUnitState) -> void:
  self.units_inside_workers.append(unit)
  self.units_inside_changed.emit()

func unit_exit(unit: RUnitState) -> void:
  var unit_index := self.units_inside_workers.find(unit)
  if unit_index != -1:
    self.units_inside_workers.erase(unit_index)
    self.units_inside_changed.emit()

## building object
@export var building: RBuilding = null
## Position of the top left edge of the building in game tile coordinates
@export var position_gt: Vector2 = Vector2.ZERO
## Array of RUnitState objects for workers inside the building
@export var units_inside_workers: Array[RUnitState] = []
