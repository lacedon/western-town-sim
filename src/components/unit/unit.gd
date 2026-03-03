extends Node2D

class_name UnitNode

const UnitAIAbstract = preload('./ai/abstract/abstract-ai.gd')
const AIHelper = preload('./ai/ai.gd')

@export var unit: RUnit = null

@onready var sprite: Sprite2D = $Sprite2D
@onready var raycast: RayCast2D = $RayCast2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var _ai_agent: UnitAIAbstract

func _ready() -> void:
  if !self.visible: return
  if !unit: return

  sprite.texture = unit.texture
  _ai_agent = AIHelper.get_ai_agent(unit, self)
  _ai_agent.connect(_ai_agent.target_changed.get_name(), set_target_position)
  _ai_agent.init()
  add_child(_ai_agent)

func _exit_tree() -> void:
  if _ai_agent:
    _ai_agent.disconnect(_ai_agent.target_changed.get_name(), set_target_position)

func _physics_process(delta: float) -> void:
  if _ai_agent.is_moving: move_to_target(delta)

func set_target_position(target_position: Vector2) -> void:
  navigation_agent.target_position = target_position

func move_to_target(delta: float) -> void:
  var next_path_position := navigation_agent.get_next_path_position()

  position = position.move_toward(next_path_position, unit.speed * delta)

  if navigation_agent.is_navigation_finished():
    _ai_agent.target_reached()
