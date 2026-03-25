extends "../../builder.gd"

const BuildingScene = preload("res://src/components/building/building.tscn")
const math_utils = preload("res://src/common/math_utils.gd")

@export var building_container: Node

@onready var building_node: BuildingNode = $Building

var _is_building_started: bool = false
var _placing_start_coordinates: Vector2 = Vector2.ZERO

func _input(event: InputEvent) -> void:
  if !_is_building_started: return

  if event is InputEventMouseMotion:
    building_node.position = Vector2(_parseCoordinate(event.position, 0), _parseCoordinate(event.position, 1))
  elif event is InputEventMouseButton:
    # Start placing building
    if event.is_pressed() && building_node.canBePlaced():
      _placing_start_coordinates = _parseCoordinates(event.position, false)
      # Place the first building in the chain
      if building_node.building.building_mode == RBuilding.BuildingMode.chaining:
        placeBuilding()
    # Mouse key is released
    elif event.is_released():
      # Place building and stop placing
      if event.button_index == MOUSE_BUTTON_LEFT:
        # Place chain of buildings
        # TODO: Refactor this mess
        if building_node.building.building_mode == RBuilding.BuildingMode.chaining:
          var targetX: float = _parseCoordinate(event.position, 0, false)
          var targetY: float = _parseCoordinate(event.position, 1, false)
          var isXBigger: bool = abs(_placing_start_coordinates.x - targetX) > abs(_placing_start_coordinates.y - targetY)

          if isXBigger:
            var xStep: int = 1 if _placing_start_coordinates.x < targetX else -1
            for x in range(_placing_start_coordinates.x, targetX, xStep):
              placeBuilding(tileCoordinatesToPixels(Vector2(x + xStep, _placing_start_coordinates.y)))
            var yStep: int = 1 if _placing_start_coordinates.y < targetY else -1
            for y in range(_placing_start_coordinates.y, targetY, yStep):
              placeBuilding(tileCoordinatesToPixels(Vector2(targetX, y + yStep)))
          else:
            var yStep: int = 1 if _placing_start_coordinates.y < targetY else -1
            for y in range(_placing_start_coordinates.y, targetY, yStep):
              placeBuilding(tileCoordinatesToPixels(Vector2(_placing_start_coordinates.x, y + yStep)))
            var xStep: int = 1 if _placing_start_coordinates.x < targetX else -1
            for x in range(_placing_start_coordinates.x, targetX, xStep):
              placeBuilding(tileCoordinatesToPixels(Vector2(x + xStep, targetY)))

        elif building_node.canBePlaced():
          placeBuilding()

        stop_building()
      # Cancel placing
      # TODO: Remove all buildings that were placed within chained placing
      elif event.button_index == MOUSE_BUTTON_RIGHT:
        stop_building()

func _parseCoordinate(eventPosition: Vector2, coordinateIndex: int, shouldReturnPixels = true) -> int:
  var tileSize: int = GameConfig.tile_size[coordinateIndex]
  var buildingSize: int = building_node.building.size[coordinateIndex]
  var tileCoordinate: float = (
    floor(eventPosition[coordinateIndex] / tileSize) +
    (0.5 if math_utils.is_odd(buildingSize) else 0.)
  )
  return floor(tileCoordinate * tileSize if shouldReturnPixels else tileCoordinate)

func _parseCoordinates(eventPosition: Vector2, shouldReturnPixels = true) -> Vector2:
  return Vector2(
    _parseCoordinate(eventPosition, 0, shouldReturnPixels),
    _parseCoordinate(eventPosition, 1, shouldReturnPixels)
  )

func tileCoordinatesToPixels(tileCoordinates: Vector2) -> Vector2:
  return Vector2(
    (tileCoordinates.x + (0.5 if math_utils.is_odd(building_node.building.size.x) else 0.))* GameConfig.tile_size.x,
    (tileCoordinates.y + (0.5 if math_utils.is_odd(building_node.building.size.y) else 0.))* GameConfig.tile_size.y
  )

func start_building(building: RBuilding) -> void:
  _is_building_started = true

  building_node.setBuilding(building)
  building_node.show()

func stop_building() -> void:
  _is_building_started = false
  building_node.setBuilding(null)
  building_node.hide()

func placeBuilding(buildingPosition: Vector2 = Vector2.INF) -> BuildingNode:
  # TODO: Rewrite to use entity-pool
  var building: BuildingNode = BuildingNode.clone(building_node)
  building.mode = BuildingNode.BuildingMode.placed
  building_container.add_child(building)
  if buildingPosition != Vector2.INF:
    building.position = buildingPosition
  building.building.on_building_placed()
  return building
