extends Node2D

class_name UnitNode

const maxTriesToFindPosition: int = 10

@export var unit: RUnit = null

@onready var sprite: Sprite2D = $Sprite2D
@onready var raycast: RayCast2D = $RayCast2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var _target_position: Vector2 = Vector2.ZERO
var _is_moving: bool = false

func _ready() -> void:
  if !self.visible: return
  if !unit: return

  sprite.texture = unit.texture
  set_random_target_within_radius()

func _process(_delta: float) -> void:
  raycast.target_position = to_local(_target_position)

func _physics_process(delta: float) -> void:
  if _is_moving: move_to_target(delta)
  else: set_random_target_within_radius()

func _generate_random_target_position() -> Vector2:
  return position + Vector2(
    randf_range(-unit.wanderingRadius, unit.wanderingRadius),
    randf_range(-unit.wanderingRadius, unit.wanderingRadius)
  )

func set_random_target_within_radius() -> void:
  _is_moving = false
  var tries: int = 0
  while tries < maxTriesToFindPosition:
    tries += 1
    var random_position: Vector2 = _generate_random_target_position()
    navigation_agent.target_position = random_position

    # if navigation_agent.is_target_reachable():
    set_target_position(random_position)
    return

func set_target_position(target_position: Vector2) -> void:
  _target_position = target_position
  navigation_agent.target_position = target_position
  _is_moving = true

func move_to_target(delta: float) -> void:
  var next_path_position := navigation_agent.get_next_path_position()

  position = position.move_toward(next_path_position, unit.speed * delta)

  if navigation_agent.is_navigation_finished():
    # position = _target_position
    set_random_target_within_radius()
