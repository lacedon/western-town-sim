extends Node2D

func _ready() -> void:
  for i in range(100):

    var x_line = Line2D.new()
    x_line.width = 1
    var x_coordinate = i * GameConfig.tileSize.x
    x_line.points = [Vector2(x_coordinate, 0), Vector2(x_coordinate, 1000)]

    var y_line = Line2D.new()
    y_line.width = 1
    var y_coordinate = i * GameConfig.tileSize.y
    y_line.points = [Vector2(0, y_coordinate), Vector2(1000, y_coordinate)]

    add_child(x_line)
    add_child(y_line)
