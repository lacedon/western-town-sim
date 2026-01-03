extends Resource

class_name RBuilding

enum BuildingMode {
  normal,
  chaining,
  rect,
}

func _init(
  _name: String,
  _size: Vector2i,
  _texture: Texture2D,
  _buildingMode: BuildingMode = BuildingMode.normal
):
  name = _name
  size = _size
  texture = _texture
  buildingMode = _buildingMode

@export var name: String = ":: Build ::"
@export var size: Vector2i = Vector2i.ONE
@export var buildingMode: BuildingMode = BuildingMode.normal
@export var texture: Texture2D

func clone() -> RBuilding:
  return RBuilding.new(
    self.name,
    self.size,
    self.texture.duplicate(),
    self.buildingMode
  )
