extends Node2D
class_name BuildingEntrance

const EntranceScene = preload("res://src/components/building_entrance/building_entrance.tscn")
const CoordinateParser = preload("res://src/common/coordinate_parser.gd")

@onready var _color_rect: ColorRect = $ColorRect
@onready var _collision_shape: CollisionShape2D = $Area2D/CollisionShape2D

@export var position_tiles: Vector2 = Vector2.ZERO:
  set(value):
    position_tiles = value
    _update_position()
@export var size_tiles: Vector2i = Vector2i.ONE:
  set(value):
    size_tiles = value
    _update_size()

static func create(_position_tiles: Vector2, _size_tiles: Vector2i = Vector2i.ONE) -> BuildingEntrance:
  var entrance: BuildingEntrance = EntranceScene.instantiate()
  entrance.position_tiles = _position_tiles
  if (entrance.size_tiles != _size_tiles):
    entrance.size_tiles = _size_tiles
  return entrance

func _ready() -> void:
  _update_size()
  _update_position()

func _update_position() -> void:
  position = CoordinateParser.game_tiles_to_pixels(self.position_tiles)

func _update_size() -> void:
  var size := CoordinateParser.game_tiles_to_pixels(self.size_tiles)
  _color_rect.size = size
  _collision_shape.shape.size = size
