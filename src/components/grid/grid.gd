extends Node2D

const line_size: int = 2000
const line_width: int = 2
const line_number: int = 100
const color: Color = Color(0.75, 0.75, 0.75, 0.25)

func _ready() -> void:
  for index in range(line_number):
    add_child(_createLine(index, true))
    add_child(_createLine(index, false))

func _createLine(index: int, is_horizontal: bool) -> Line2D:
    var line = Line2D.new()
    line.width = line_width
    line.default_color = color
    var coordinate = index * (GameConfig.tile_size.x if is_horizontal else GameConfig.tile_size.y)
    line.points = [Vector2(coordinate, 0), Vector2(coordinate, line_size)] if is_horizontal else [Vector2(0, coordinate), Vector2(line_size, coordinate)]
    return line
