extends Node2D

const lineSize: int = 2000
const lineWidth: int = 2
const lineNumber: int = 100
const color: Color = Color(0.75, 0.75, 0.75, 0.25)

func _ready() -> void:
  for index in range(lineNumber):
    add_child(_createLine(index, true))
    add_child(_createLine(index, false))

func _createLine(index: int, isHorizontal: bool) -> Line2D:
    var line = Line2D.new()
    line.width = lineWidth
    line.default_color = color
    var coordinate = index * (GameConfig.tile_size.x if isHorizontal else GameConfig.tile_size.y)
    line.points = [Vector2(coordinate, 0), Vector2(coordinate, lineSize)] if isHorizontal else [Vector2(0, coordinate), Vector2(lineSize, coordinate)]
    return line
