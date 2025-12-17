extends Resource

class_name RBuilding

func _init(
  _name: String,
  _size: Vector2i,
  _texture: Texture2D
):
  name = _name
  size = _size
  texture = _texture

@export var name: String = ":: Build ::"
@export var size: Vector2i = Vector2i.ONE
@export var texture: Texture2D
