extends Resource

## Has all the static information to define the building
## Should not contain any dynamic data. Use RBuildingState for that
class_name RBuilding

enum BuildingMode {
  normal,
  chaining,
  rect,
}

func _init(
  _name: String = self.name,
  _size: Vector2i = self.size,
  _texture: Texture2D = self.texture,
  _building_mode: BuildingMode = self.building_mode,
  _functions: Array[BuildingFunction] = self.functions,
  _entrances: Array[Vector2] = self.entrances,
):
  self.name = _name
  self.size = _size
  self.texture = _texture
  self.building_mode = _building_mode
  self.functions = _functions
  self.entrances = _entrances

@export var name: String = ":: Building ::"
@export var size: Vector2i = Vector2i.ONE
@export var building_mode: BuildingMode = BuildingMode.normal
@export var texture: Texture2D
@export var functions: Array[BuildingFunction] = []
## Array of game tile coordinates for each entrance in the building
@export var entrances: Array[Vector2] = []

func on_building_placed(building_state: RBuildingState) -> void:
  for function in functions:
    function.on_building_placed(self, building_state)

func on_building_destroyed(building_state: RBuildingState) -> void:
  for function in functions:
    function.on_building_destroyed(self, building_state)

func on_day_change(building_state: RBuildingState) -> void:
  for function in functions:
    function.on_day_change(self, building_state)

## Returns absolute position of a random entrance in game tile coordinates
func get_entrance_position_gt(building_state: RBuildingState) -> Vector2:
  var entrance: Vector2 = self.entrances.pick_random()
  return building_state.position_gt + entrance
