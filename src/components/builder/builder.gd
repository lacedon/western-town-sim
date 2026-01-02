extends Node2D

const eventConstants = preload("res://src/constants/events.gd")
const testBuildingTexture11 = preload("res://resources/images/1x1.png")
const testBuildingTexture22 = preload("res://resources/images/2x2.png")
const testBuildingTexture23 = preload("res://resources/images/2x3.png")
const testBuildingTexture33 = preload("res://resources/images/3x3.png")
const BuildingScene = preload("res://src/components/building/building.tscn")

@export var buildingContainer: Node

@onready var buildingNode: BuildingNode = $Building

var _isBuildingStarted: bool = false

var _buildingIndex: int = 0
var _buildings: Array[RBuilding] = [
  RBuilding.new("Test-1x1", Vector2(1, 1), testBuildingTexture11),
  RBuilding.new("Test-2x2", Vector2(2, 2), testBuildingTexture22),
  RBuilding.new("Test-2x3", Vector2(3, 2), testBuildingTexture23),
  RBuilding.new("Test-3x3", Vector2(3, 3), testBuildingTexture33),
]

func _ready() -> void:
  EventEmitter.addListener(eventConstants.START_BUILDING, toggleBuilding)
  buildingNode.connect(buildingNode.areaEnteredExited.get_name(), _updateBuildingColoring)

func _exit_tree() -> void:
  EventEmitter.removeListener(eventConstants.START_BUILDING, toggleBuilding)
  buildingNode.disconnect(buildingNode.areaEnteredExited.get_name(), _updateBuildingColoring)

func _input(event: InputEvent) -> void:
  if !_isBuildingStarted: return

  if event is InputEventMouseMotion:
    buildingNode.position = (
      Vector2(
        round(event.position.x / GameConfig.tileSize.x),
        round(event.position.y / GameConfig.tileSize.y)
      ) + (Vector2(buildingNode.building.size) / 2)
     ) * GameConfig.tileSize.x
  elif event is InputEventMouseButton && event.is_pressed():
    if buildingNode.canBePlaced():
      placeBuilding()
      toggleBuilding()

func _updateBuildingColoring() -> void:
  buildingNode.updateColoring()

func toggleBuilding() -> void:
  if _isBuildingStarted:
    _isBuildingStarted = false
    buildingNode.setBuilding(null)
    buildingNode.hide()
    _buildingIndex = (_buildingIndex + 1) % _buildings.size()
  else:
    _isBuildingStarted = true

    var building: RBuilding = _buildings[_buildingIndex]
    buildingNode.setBuilding(building)
    buildingNode.show()

func placeBuilding() -> void:
  # TODO: Rewrite to use entity-pool
  var building: BuildingNode = BuildingNode.clone(buildingNode)
  building.mode = BuildingNode.BuildingMode.placed
  buildingContainer.add_child(building)
