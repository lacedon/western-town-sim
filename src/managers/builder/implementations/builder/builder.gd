extends "../../builder.gd"

const BuildingScene = preload("res://src/components/building/building.tscn")
const isOdd = preload("res://src/common/is_odd.gd")

@export var buildingContainer: Node

@onready var buildingNode: BuildingNode = $Building

var _isBuildingStarted: bool = false
var _isPlacingStarted: bool = false
var _placingStartCoordinates: Vector2 = Vector2.ZERO

func _ready() -> void:
  buildingNode.connect(buildingNode.areaEnteredExited.get_name(), _updateBuildingColoring)

func _exit_tree() -> void:
  buildingNode.disconnect(buildingNode.areaEnteredExited.get_name(), _updateBuildingColoring)

func _input(event: InputEvent) -> void:
  if !_isBuildingStarted: return

  if event is InputEventMouseMotion:
    buildingNode.position = Vector2(_parseCoordinate(event.position, 0), _parseCoordinate(event.position, 1))
  elif event is InputEventMouseButton:
    # Start placing building
    if event.is_pressed() && buildingNode.canBePlaced():
      _isPlacingStarted = true
      _placingStartCoordinates = _parseCoordinates(event.position, false)
      # Place the first building in the chain
      if buildingNode.building.buildingMode == RBuilding.BuildingMode.chaining:
        placeBuilding()
    # Mouse key is released
    elif event.is_released():
      # Place building and stop placing
      if event.button_index == MOUSE_BUTTON_LEFT:
        # Place chain of buildings
        # TODO: Refactor this mess
        if buildingNode.building.buildingMode == RBuilding.BuildingMode.chaining:
          var targetX: float = _parseCoordinate(event.position, 0, false)
          var targetY: float = _parseCoordinate(event.position, 1, false)
          var isXBigger: bool = abs(_placingStartCoordinates.x - targetX) > abs(_placingStartCoordinates.y - targetY)

          if isXBigger:
            var xStep: int = 1 if _placingStartCoordinates.x < targetX else -1
            for x in range(_placingStartCoordinates.x, targetX, xStep):
              placeBuilding(tileCoordinatesToPixels(Vector2(x + xStep, _placingStartCoordinates.y)))
            var yStep: int = 1 if _placingStartCoordinates.y < targetY else -1
            for y in range(_placingStartCoordinates.y, targetY, yStep):
              placeBuilding(tileCoordinatesToPixels(Vector2(targetX, y + yStep)))
          else:
            var yStep: int = 1 if _placingStartCoordinates.y < targetY else -1
            for y in range(_placingStartCoordinates.y, targetY, yStep):
              placeBuilding(tileCoordinatesToPixels(Vector2(_placingStartCoordinates.x, y + yStep)))
            var xStep: int = 1 if _placingStartCoordinates.x < targetX else -1
            for x in range(_placingStartCoordinates.x, targetX, xStep):
              placeBuilding(tileCoordinatesToPixels(Vector2(x + xStep, targetY)))

        elif buildingNode.canBePlaced():
          placeBuilding()

        stop_building()
      # Cancel placing
      # TODO: Remove all buildings that were placed within chained placing
      elif event.button_index == MOUSE_BUTTON_RIGHT:
        stop_building()

func _parseCoordinate(eventPosition: Vector2, coordinateIndex: int, shouldReturnPixels = true) -> int:
  var tileSize: int = GameConfig.tile_size[coordinateIndex]
  var buildingSize: int = buildingNode.building.size[coordinateIndex]
  var tileCoordinate: float = (
    floor(eventPosition[coordinateIndex] / tileSize) +
    (0.5 if isOdd.isOdd(buildingSize) else 0.)
  )
  return floor(tileCoordinate * tileSize if shouldReturnPixels else tileCoordinate)

func _parseCoordinates(eventPosition: Vector2, shouldReturnPixels = true) -> Vector2:
  return Vector2(
    _parseCoordinate(eventPosition, 0, shouldReturnPixels),
    _parseCoordinate(eventPosition, 1, shouldReturnPixels)
  )

func tileCoordinatesToPixels(tileCoordinates: Vector2) -> Vector2:
  return Vector2(
    (tileCoordinates.x + (0.5 if isOdd.isOdd(buildingNode.building.size.x) else 0.))* GameConfig.tile_size.x,
    (tileCoordinates.y + (0.5 if isOdd.isOdd(buildingNode.building.size.y) else 0.))* GameConfig.tile_size.y
  )

func _updateBuildingColoring() -> void:
  buildingNode.updateColoring()

func start_building(building: RBuilding) -> void:
  _isBuildingStarted = true

  buildingNode.setBuilding(building)
  buildingNode.show()

func stop_building() -> void:
  _isBuildingStarted = false
  _isPlacingStarted = false
  buildingNode.setBuilding(null)
  buildingNode.hide()

func placeBuilding(buildingPosition: Vector2 = Vector2.INF) -> BuildingNode:
  # TODO: Rewrite to use entity-pool
  var building: BuildingNode = BuildingNode.clone(buildingNode)
  building.mode = BuildingNode.BuildingMode.placed
  buildingContainer.add_child(building)
  if buildingPosition != Vector2.INF:
    building.position = buildingPosition
  building.building.onBuildingPlaced()
  return building
