extends Node2D

class_name UnitNode

@export var unit: RUnit = null

@onready var sprite: Sprite2D = $Sprite2D
@onready var raycast: RayCast2D = $RayCast2D

var _target_position: Vector2 = Vector2.ZERO
var _is_moving: bool = false

func _ready() -> void:
  if !unit: return

  sprite.texture = unit.texture
  set_random_target_within_radius()

func _process(delta: float) -> void:
  if _is_moving: move_to_target(delta)
  raycast.target_position = to_local(_target_position)

func _generate_random_target_position() -> Vector2:
  return position + Vector2(
    randf_range(-unit.wanderingRadius, unit.wanderingRadius),
    randf_range(-unit.wanderingRadius, unit.wanderingRadius)
  )

func set_random_target_within_radius() -> void:
  var is_position_invalid: bool = true
  while is_position_invalid:
    var random_position: Vector2 = _generate_random_target_position()
    raycast.target_position = to_local(random_position)
    raycast.force_raycast_update()

    is_position_invalid = raycast.is_colliding()
    if !is_position_invalid: set_target_position(random_position)

func set_target_position(target_position: Vector2) -> void:
  _target_position = target_position
  _is_moving = true

func move_to_target(delta: float) -> void:
  position = position.move_toward(_target_position, unit.speed * delta)
  var difference: float = position.distance_to(_target_position)

  if difference < 1.0:
    position = _target_position
    set_random_target_within_radius()
