extends Resource

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
  _buildingMode: BuildingMode = self.buildingMode,
  _functions: Array[BuildingFunction] = self.functions,
  _entrances: Array[Vector2] = self.entrances
):
  self.name = _name
  self.size = _size
  self.texture = _texture
  self.buildingMode = _buildingMode
  self.functions = _functions
  self.entrances = _entrances

@export var name: String = ":: Building ::"
@export var size: Vector2i = Vector2i.ONE
@export var buildingMode: BuildingMode = BuildingMode.normal
@export var texture: Texture2D
@export var functions: Array[BuildingFunction] = []
@export var entrances: Array[Vector2] = []

func clone() -> RBuilding:
  return RBuilding.new(
    self.name,
    self.size,
    self.texture.duplicate(),
    self.buildingMode,
    self.functions,
    self.entrances.duplicate()
  )

func onBuildingPlaced() -> void:
  for function in functions:
    function.onBuildingPlaced(self)

func onBuildingDestroyed() -> void:
  for function in functions:
    function.onBuildingDestroyed(self)

func onDayChange(position: Vector2) -> void:
  for function in functions:
    function.onDayChange(self, position)
