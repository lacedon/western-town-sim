## The abstract class for citizen's AI state
## The citizen AI should work by switching the states to represent different behaviors
## TODO: The current aproach works as set target-finish target-change state
## This aproach is missing handling dynamic events(e.g. attack by enemy during execution)
## Need to add some method that would handle these events

@abstract
extends Node
class_name AbstractCitizenState

static func try_translate_to(_current_state: AbstractCitizenState) -> AbstractCitizenState:
  return null

@export var unit: RUnit
@export var unit_state: RUnitState
@export var node: Node2D
@export var ai: CitizenAI

func define(new_unit: RUnit, new_unit_state: RUnitState, new_node: Node2D, new_ai: CitizenAI) -> AbstractCitizenState:
  self.unit = new_unit
  self.unit_state = new_unit_state
  self.node = new_node
  self.ai = new_ai
  return self

func copy(state: AbstractCitizenState) -> AbstractCitizenState:
  return self.define(state.unit, state.unit_state, state.node, state.ai)

func stop() -> void:
  pass

func target_reached() -> void:
  pass

@abstract func init() -> void
