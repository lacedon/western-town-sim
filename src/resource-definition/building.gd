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
):
  self.name = _name
  self.size = _size
  self.texture = _texture
  self.buildingMode = _buildingMode
  self.functions = _functions

@export var name: String = ":: Building ::"
@export var size: Vector2i = Vector2i.ONE
@export var buildingMode: BuildingMode = BuildingMode.normal
@export var texture: Texture2D
@export var functions: Array[BuildingFunction] = []

func clone() -> RBuilding:
  return RBuilding.new(
    self.name,
    self.size,
    self.texture.duplicate(),
    self.buildingMode,
    self.functions,
  )
