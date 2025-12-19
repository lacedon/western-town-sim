extends Node2D

const eventConstants = preload("res://src/constants/events.gd")
const testBuildingTexture = preload("res://resources/images/building6464.png")
const BuildingScene = preload("res://src/components/building/building.tscn")

@export var buildingContainer: Node

@onready var buildingNode: BuildingNode = $Building

var _isBuildingStarted: bool = false

func _ready() -> void:
  EventEmitter.addListener(eventConstants.START_BUILDING, toggleBuilding)
  buildingNode.connect(buildingNode.areaEnteredExited.get_name(), _updateBuildingColoring)

func _exit_tree() -> void:
  EventEmitter.removeListener(eventConstants.START_BUILDING, toggleBuilding)
  buildingNode.disconnect(buildingNode.areaEnteredExited.get_name(), _updateBuildingColoring)

func _input(event: InputEvent) -> void:
  if !_isBuildingStarted: return

  if event is InputEventMouseMotion:
    buildingNode.position = Vector2i(
      round(event.position.x / GameConfig.tileSize.x),
      round(event.position.y / GameConfig.tileSize.y)
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
  else:
    _isBuildingStarted = true

    var building: RBuilding = RBuilding.new("Test", Vector2(2, 2), testBuildingTexture)
    buildingNode.setBuilding(building)
    buildingNode.show()

func placeBuilding() -> void:
  # TODO: Rewrite to use entity-pool
  var building: BuildingNode = BuildingScene.instantiate()
  building.building = buildingNode.building
  building.mode = BuildingNode.BuildingMode.placed
  building.position = buildingNode.position
  buildingContainer.add_child(building)
