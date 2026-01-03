extends Node2D

const eventConstants = preload("res://src/constants/events.gd")
const testBuildingTexture11 = preload("res://resources/images/1x1.png")
const testBuildingTexture22 = preload("res://resources/images/2x2.png")
const testBuildingTexture23 = preload("res://resources/images/2x3.png")
const testBuildingTexture33 = preload("res://resources/images/3x3.png")
const BuildingScene = preload("res://src/components/building/building.tscn")
const isOdd = preload("res://src/common/is-odd.gd")

@export var buildingContainer: Node

@onready var buildingNode: BuildingNode = $Building

var _isBuildingStarted: bool = false
var _isPlacingStarted: bool = false
var _placingStartCoordinates: Vector2 = Vector2.ZERO

var _buildingIndex: int = 0
var _buildings: Array[RBuilding] = [
  RBuilding.new("Test-1x1", Vector2(1, 1), testBuildingTexture11, RBuilding.BuildingMode.chaining),
  RBuilding.new("Test-2x2", Vector2(2, 2), testBuildingTexture22),
  RBuilding.new("Test-2x3", Vector2(3, 2), testBuildingTexture23),
  RBuilding.new("Test-3x3", Vector2(3, 3), testBuildingTexture33),
]

func _ready() -> void:
  EventEmitter.addListener(eventConstants.START_BUILDING, startPlacingBuilding)
  buildingNode.connect(buildingNode.areaEnteredExited.get_name(), _updateBuildingColoring)

func _exit_tree() -> void:
  EventEmitter.removeListener(eventConstants.START_BUILDING, startPlacingBuilding)
  buildingNode.disconnect(buildingNode.areaEnteredExited.get_name(), _updateBuildingColoring)

func _input(event: InputEvent) -> void:
  if !_isBuildingStarted: return

  if event is InputEventMouseMotion:
    buildingNode.position = Vector2(_parseCoordinate(event.position, 0), _parseCoordinate(event.position, 1))
  elif event is InputEventMouseButton:
    # Start placing building
    if event.is_pressed() && buildingNode.canBePlaced():
      _isPlacingStarted = true
      _placingStartCoordinates = event.position
      # Place the first building in the chain
      if buildingNode.building.buildingMode == RBuilding.BuildingMode.chaining:
        placeBuilding()
    # Mouse key is released
    elif event.is_released():
      # Place building and stop placing
      if event.button_index == MOUSE_BUTTON_LEFT:
        # Place chain of buildings
        # TODO: Fix it. Should make a line of the buildings
        if buildingNode.building.buildingMode == RBuilding.BuildingMode.chaining:
          var targetX: float = _parseCoordinate(event.position, 0, false)
          var targetY: float = _parseCoordinate(event.position, 0, false)
          var minStepCount: int = floor(min(abs(_placingStartCoordinates.x - targetX), abs(_placingStartCoordinates.y - targetY)))
          prints('minStepCount', minStepCount)
          for stepIndex in range(minStepCount):
            var placedBuilding = placeBuilding()
            placedBuilding.position = Vector2(
              (targetX + stepIndex) * GameConfig.tileSize.x,
              (targetY + stepIndex) * GameConfig.tileSize.y
            )

        elif buildingNode.canBePlaced():
          placeBuilding()

        stopPlacingBuilding()
      # Cancel placing
      # TODO: Remove all buildings that were placed within chained placing
      elif event.button_index == MOUSE_BUTTON_RIGHT:
        stopPlacingBuilding()

func _parseCoordinate(eventPosition: Vector2, coordinateIndex: int, shouldReturnPixels = true) -> int:
  var tileSize: int = GameConfig.tileSize[coordinateIndex]
  var buildingSize: int = buildingNode.building.size[coordinateIndex]
  var tileCoordinate: float = (
    floor(eventPosition[coordinateIndex] / tileSize) +
    (0.5 if isOdd.isOdd(buildingSize) else 0.)
  )
  return tileCoordinate * tileSize if shouldReturnPixels else tileCoordinate

func _updateBuildingColoring() -> void:
  buildingNode.updateColoring()

func startPlacingBuilding() -> void:
    _isBuildingStarted = true

    var building: RBuilding = _buildings[_buildingIndex]
    buildingNode.setBuilding(building)
    buildingNode.show()

func stopPlacingBuilding() -> void:
  _isBuildingStarted = false
  _isPlacingStarted = false
  buildingNode.setBuilding(null)
  buildingNode.hide()
  _buildingIndex = (_buildingIndex + 1) % _buildings.size()

func placeBuilding() -> BuildingNode:
  # TODO: Rewrite to use entity-pool
  var building: BuildingNode = BuildingNode.clone(buildingNode)
  building.mode = BuildingNode.BuildingMode.placed
  buildingContainer.add_child(building)
  return building
