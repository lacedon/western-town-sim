const AIAgents = preload("res://src/types/ai_agents.gd").AIAgents
const UnitAIAbstract = preload('./abstract/abstract_ai.gd')
const UnitAIWanderer = preload('./wanderer/wanderer.gd')
const UnitAICitizen = preload('./citizen/citizen.gd')

static func get_ai_agent(
  unit: RUnit,
  unit_state: RUnitState,
  node: Node2D,
) -> UnitAIAbstract:
  match unit.ai_agent:
    AIAgents.Wanderer:
      return UnitAIWanderer.new(unit, unit_state, node)
    AIAgents.Citizen:
      return UnitAICitizen.new(unit, unit_state, node)

  prints('[WARNING] No AI agent found for type:', unit.ai_agent)
  return UnitAIWanderer.new(unit, unit_state, node)
