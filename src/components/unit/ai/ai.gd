const AIAgents = preload("res://src/types/ai-agents.gd").AIAgents
const UnitAIAbstract = preload('./abstract/abstract-ai.gd')
const UnitAIWanderer = preload('./wanderer/wanderer.gd')
const UnitAICitizen = preload('./citizen/citizen.gd')

static func get_ai_agent(
  unit: RUnit,
  node: Node2D,
) -> UnitAIAbstract:
  match unit.ai_agent:
    AIAgents.Wanderer:
      return UnitAIWanderer.new(unit, node)
    AIAgents.Citizen:
      return UnitAICitizen.new(unit, node)

  prints('[WARNING] No AI agent found for type:', unit.ai_agent)
  return UnitAIWanderer.new(unit, node)
