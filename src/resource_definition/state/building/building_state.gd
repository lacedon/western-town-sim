extends Resource

class_name RBuildingState

func _init(
  _position_gt: Vector2 = self.position_gt,
  _units_inside_workers: Array[RID] = self.units_inside_workers
):
  self.position_gt = _position_gt
  self.units_inside_workers = _units_inside_workers

func clone():
  return RBuildingState.new(self.position_gt, self.units_inside_workers)

## Position of the top left edge of the building in game tile coordinates
@export var position_gt: Vector2 = Vector2.ZERO
## Array of RIDs for workers inside the building
@export var units_inside_workers: Array[RID] = []
