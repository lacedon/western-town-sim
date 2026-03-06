extends Node

class_name EntityPool

enum IncrementMode {
  ## Multiply the current entity number on [incrementStep]
  ## @example: initNumberOfEntities=10, incrementStep=2: Have 20 entities after incrementation
  multiplication,
  ## Add [incrementStep] when all available entities are used
  ## @example: initNumberOfEntities=10, incrementStep=5: Have 15 entities after incrementation
  iteration,
}

## Method to create a new entity
@export var createNewEntity: Callable
## Parent node that contains the entities
@export var entityContainer: Node = self
## Name used for all entities. Add the entity number at the end. Pass empty to ignore
@export var baseEntityName: String = 'Entity:'

## Contain configuration for the number of entities that should be added once the current pool is used
@export_category("Incrementation")
## Base number of entities on the moment of the node readiness
@export_range(1, 100, 1, "or_greater") var initNumberOfEntities: int = 10
## Method of increasing the number of entities
@export var incrementMode: IncrementMode = IncrementMode.iteration
## Argument for the incrementMode
@export_range(1, 20, 1, "or_greater") var incrementStep: int = 10

var _entityNumber: int = 0
var _availableEntities: Array[Node] = []
var _usedEntities: Array[Node] = []

func _ready() -> void:
  for index in range(initNumberOfEntities):
    _createEntity()

func getNewEntity() -> Node:
  if (_availableEntities.size() == 0):
    _incrementEntities()

  var entity: Node = _availableEntities.pop_back()
  entity.show()
  _usedEntities.append(entity)
  return entity

func getAllUsedEntities() -> Array[Node]:
  return _usedEntities

func deleteEntity(entity: Node) -> void:
  var usedEntityIndex: int = _usedEntities.find(entity)
  if usedEntityIndex > -1:
    entity.hide()
    _availableEntities.append(entity)

func deleteAllEntities() -> void:
  for entity in _usedEntities:
    entity.hide()
  _availableEntities.append_array(_usedEntities)
  _usedEntities.clear()

func _incrementEntities() -> void:
  match (incrementMode):
    IncrementMode.multiplication:
      for index in range(_entityNumber * incrementStep - _entityNumber):
        _createEntity()
    IncrementMode.iteration:
      for index in range(incrementStep):
        _createEntity()

func _createEntity() -> void:
    var entity: Node = createNewEntity.call(_entityNumber)
    if baseEntityName:
      entity.name = baseEntityName + str(_entityNumber)
    entity.hide()
    entityContainer.add_child(entity)
    _availableEntities.append(entity)

    _entityNumber += 1
