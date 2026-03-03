extends Resource

class_name RUnit

const AIAgents = preload("res://src/types/ai-agents.gd").AIAgents

@export var name: String = ":: Unit ::"
@export var texture: Texture2D
@export var speed: float = 25.0
@export var health: int = 100
@export var wandering_radius: float = 25.0
@export var ai_agent: AIAgents = AIAgents.Wanderer
