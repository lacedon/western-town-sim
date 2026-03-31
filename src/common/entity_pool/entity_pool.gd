extends Node

class_name EntityPool

enum IncrementMode {
  ## Multiply the current entity number on [increment_step]
  ## @example: init_number_of_entities=10, increment_step=2: Have 20 entities after incrementation
  multiplication,
  ## Add [increment_step] when all available entities are used
  ## @example: init_number_of_entities=10, increment_step=5: Have 15 entities after incrementation
  iteration,
}

## Method to create a new entity
@export var create_new_entity: Callable
## Parent node that contains the entities
@export var entity_container: Node = self
## Name used for all entities. Add the entity number at the end. Pass empty to ignore
@export var base_entity_name: String = 'Entity:'

## Contain configuration for the number of entities that should be added once the current pool is used
@export_category("Incrementation")
## Base number of entities on the moment of the node readiness
@export_range(1, 100, 1, "or_greater") var init_number_of_entities: int = 10
## Method of increasing the number of entities
@export var increment_mode: IncrementMode = IncrementMode.iteration
## Argument for the increment_mode
@export_range(1, 20, 1, "or_greater") var increment_step: int = 10

var _entity_number: int = 0
var _available_entities: Array[Node] = []
var _used_entities: Array[Node] = []

func _ready() -> void:
  for index in range(init_number_of_entities):
    _createEntity()

func getNewEntity() -> Node:
  if (_available_entities.size() == 0):
    _incrementEntities()

  var entity: Node = _available_entities.pop_back()
  entity.show()
  _used_entities.append(entity)
  return entity

func getAllUsedEntities() -> Array[Node]:
  return _used_entities

func deleteEntity(entity: Node) -> void:
  var used_entity_index: int = _used_entities.find(entity)
  if used_entity_index > -1:
    entity.hide()
    _available_entities.append(entity)

func deleteAllEntities() -> void:
  for entity in _used_entities:
    entity.hide()
  _available_entities.append_array(_used_entities)
  _used_entities.clear()

func _incrementEntities() -> void:
  match (increment_mode):
    IncrementMode.multiplication:
      for index in range(_entity_number * increment_step - _entity_number):
        _createEntity()
    IncrementMode.iteration:
      for index in range(increment_step):
        _createEntity()

func _createEntity() -> void:
    var entity: Node = create_new_entity.call(_entity_number)
    if base_entity_name:
      entity.name = base_entity_name + str(_entity_number)
    entity.hide()
    entity_container.add_child(entity)
    _available_entities.append(entity)

    _entity_number += 1
