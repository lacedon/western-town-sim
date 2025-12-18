extends Node2D

const eventConstants = preload("res://src/constants/events.gd")
const testBuildingTexture = preload("res://resources/images/building6464.png")

@onready var buildingNode: BuildingNode = $Building

var _isBuildingStarted: bool = false

func _ready() -> void:
  EventEmitter.addListener(eventConstants.START_BUILDING, startBuilding)

func _exit_tree() -> void:
  EventEmitter.removeListener(eventConstants.START_BUILDING, startBuilding)

func _input(event: InputEvent) -> void:
  if _isBuildingStarted && event is InputEventMouseMotion:
    buildingNode.position = Vector2i(
      round(event.position.x / GameConfig.tileSize.x),
      round(event.position.y / GameConfig.tileSize.y)
    ) * GameConfig.tileSize.x

func startBuilding() -> void:
  if _isBuildingStarted:
    _isBuildingStarted = false
    buildingNode.setBuilding(null)
    buildingNode.hide()
  else:
    _isBuildingStarted = true

    var building: RBuilding = RBuilding.new("Test", Vector2(2, 2), testBuildingTexture)
    buildingNode.setBuilding(building)
    buildingNode.show()
