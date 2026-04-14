extends "../../builder.gd"

const BuildingScene = preload("res://src/components/building/building.tscn")
const MathUtils = preload("res://src/common/math_utils.gd")
const CoordinateParser = preload("res://src/common/coordinate_parser.gd")

@export var building_container: Node

@onready var building_node: BuildingNode = $Building

## Shows if builer should listen for input events and place building
var _is_building_started: bool = false
## Coordinates in game tiles of the first building placement
var _placing_start_coordinates_gt: Vector2 = Vector2.ZERO
## Offset in pixels for building placement. Required for proper alignment building with odd side(e.g. 2x3 - need 0.5 offset for y)
var _building_offset_px: Vector2 = Vector2.ZERO

func _input(event: InputEvent) -> void:
  if !_is_building_started: return

  if event is InputEventMouseMotion:
    building_node.position = CoordinateParser.snap_pixels_to_grid(event.position) + _building_offset_px

  elif event is InputEventMouseButton:
    # Mouse button is preseed - Start placing building
    if event.is_pressed() && building_node.can_be_placed():
      _placing_start_coordinates_gt = CoordinateParser.pixels_to_game_tiles(event.position)
      # Place the first building in the chain
      if building_node.building.building_mode == RBuilding.BuildingMode.chaining:
        _place_building(_placing_start_coordinates_gt)

    # Mouse key is released - Finish placeing chain of building or place the single building
    elif event.is_released():
      # Place building and stop placing
      if event.button_index == MOUSE_BUTTON_LEFT:
        # Place chain of buildings
        # TODO: Refactor this mess
        if building_node.building.building_mode == RBuilding.BuildingMode.chaining:
          var target: Vector2 = CoordinateParser.pixels_to_game_tiles(event.position)
          _place_chain_of_building_to(target)
          stop_building()
        elif building_node.can_be_placed():
          var target: Vector2 = CoordinateParser.pixels_to_game_tiles(event.position)
          _place_building(target)
          stop_building()

      # Cancel placing
      # TODO: Remove all buildings that were placed within chained placing
      elif event.button_index == MOUSE_BUTTON_RIGHT:
        stop_building()

func start_building(building: RBuilding) -> void:
  _is_building_started = true
  _set_up_building_offset(building)

  building_node.set_building(building)
  building_node.show()

func stop_building() -> void:
  _is_building_started = false
  building_node.set_building(null)
  building_node.hide()

## Add offset for odd sized buildings as during placement it's located in the middle of the cursor position
func _set_up_building_offset(building: RBuilding) -> void:
  _building_offset_px.x = round(float(GameConfig.tile_size.x) / 2) if MathUtils.is_odd(building.size.x) else 0
  _building_offset_px.y = round(float(GameConfig.tile_size.y) / 2) if MathUtils.is_odd(building.size.y) else 0

## Place one building at the position in game tiles
func _place_building(position_gt: Vector2) -> BuildingNode:
  var building_position_px: Vector2 = CoordinateParser.game_tiles_to_pixels(position_gt) + _building_offset_px

  # TODO: Rewrite to use entity-pool
  var building: BuildingNode = BuildingNode.clone(building_node)
  building.mode = BuildingNode.BuildingMode.placed
  building.position = building_position_px

  building_container.add_child(building)
  building.building.on_building_placed()
  return building

## Place a chain of building from _placing_start_coordinates_gt to 
func _place_chain_of_building_to(target_gt: Vector2) -> void:
  ## If x is bigger then y, then x chain of buildings should be longer, and wise-versa
  var is_x_bigger_y: bool = abs(_placing_start_coordinates_gt.x - target_gt.x) > abs(_placing_start_coordinates_gt.y - target_gt.y)
  ## Chain of building consist of 2 line: horizontal and vertical, both of which has a static coordinate
  ## Depend on if x is bigger then y define those static coordinates
  var static_line_coordinates_gt: Vector2 = Vector2(target_gt.x, _placing_start_coordinates_gt.y) if is_x_bigger_y else Vector2(_placing_start_coordinates_gt.x, target_gt.y)

  ## Horizontal part of the chain
  var x_step_gt: int = 1 if _placing_start_coordinates_gt.x < target_gt.x else -1
  for x in range(_placing_start_coordinates_gt.x + x_step_gt, target_gt.x + x_step_gt, x_step_gt):
    _place_building(Vector2(x, static_line_coordinates_gt.y))

  ## Vertical part of the chain
  var y_step_gt: int = 1 if _placing_start_coordinates_gt.y < target_gt.y else -1
  for y in range(_placing_start_coordinates_gt.y + y_step_gt, target_gt.y + y_step_gt, y_step_gt):
    _place_building(Vector2(static_line_coordinates_gt.x, y))
