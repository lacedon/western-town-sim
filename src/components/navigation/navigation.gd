extends Node2D

const events = preload('res://src/constants/events.gd')

@export var size: Vector2i = Vector2i.ZERO
@export var position_offset: Vector2 = Vector2.ZERO

@onready var debugPolygonParent: Node = $DebugPolygons
@onready var navigationRegion: NavigationRegion2D = $NavigationRegion2D

var _obstacles: Array[PackedVector2Array] = []
var navigation_mesh: NavigationPolygon
var source_geometry : NavigationMeshSourceGeometryData2D
var region_rid: RID
var map_rid: RID

var should_rebake: bool = false
var is_baking_in_process: bool = false

func _ready() -> void:
  EventEmitter.add_listener(events.ADD_ENVIRONMENT_OBSTACLE, self._on_add_environment_obstacle)
  EventEmitter.add_listener(events.REMOVE_ENVIRONMENT_OBSTACLE, self._on_remove_environment_obstacle)

  map_rid = _create_map()
  # region_rid = _create_region(map_rid)
  region_rid = navigationRegion.get_rid()
  source_geometry = _create_source_geometry()
  # navigation_mesh = _create_region_mesh()
  navigation_mesh = navigationRegion.navigation_polygon

  parse_source_geometry.call_deferred()

func _exit_tree() -> void:
  EventEmitter.remove_listener(events.ADD_ENVIRONMENT_OBSTACLE, self._on_add_environment_obstacle)
  EventEmitter.remove_listener(events.REMOVE_ENVIRONMENT_OBSTACLE, self._on_remove_environment_obstacle)

func _create_map() -> RID:
  return get_world_2d().get_navigation_map()

func _create_region(map: RID) -> RID:
  var region: RID = NavigationServer2D.region_create()
  NavigationServer2D.region_set_enabled(region, true)
  NavigationServer2D.region_set_map(region, map)
  return region

func _create_source_geometry() -> NavigationMeshSourceGeometryData2D:
  var new_source_geometry: NavigationMeshSourceGeometryData2D = NavigationMeshSourceGeometryData2D.new()

  return new_source_geometry

func parse_source_geometry() -> void:
  source_geometry.clear()
  var root_node: Node2D = self

  # Parse the obstruction outlines from all child nodes of the root node by default.
  NavigationServer2D.parse_source_geometry_data(
    navigation_mesh,
    source_geometry,
    root_node,
    rebake_navigation,
  )

func _create_region_mesh() -> NavigationPolygon:
  var new_navigation_mesh: = NavigationPolygon.new()
  new_navigation_mesh.agent_radius = 4

  # NavigationServer2D.region_set_navigation_polygon(region_rid, new_navigation_mesh)
  # NavigationServer2D.bake_from_source_geometry_data(new_navigation_mesh, source_geometry);

  return new_navigation_mesh

func rebake_navigation() -> void:
  if is_baking_in_process:
    should_rebake = true
    return

  is_baking_in_process = true

  # If we did not parse a TileMap with navigation mesh cells we may now only
  # have obstruction outlines so add at least one traversable outline
  # so the obstructions outlines have something to "cut" into.
  source_geometry.add_traversable_outline(PackedVector2Array([
    Vector2(0, 0),
    Vector2(0, GameConfig.start_navigation_region_size.y),
    Vector2(GameConfig.start_navigation_region_size.x, GameConfig.start_navigation_region_size.y),
    Vector2(GameConfig.start_navigation_region_size.x, 0)
  ]))

  for obstacle in _obstacles:
    source_geometry.add_projected_obstruction(obstacle, false)

  # Bake the navigation mesh on a thread with the source geometry data.
  NavigationServer2D.bake_from_source_geometry_data_async(
    navigation_mesh,
    source_geometry,
    on_baking_done
  )

func on_baking_done() -> void:
  # Update the region with the updated navigation mesh.
  NavigationServer2D.region_set_navigation_polygon(region_rid, navigation_mesh)

  is_baking_in_process = false
  if should_rebake:
    should_rebake = false
    rebake_navigation()

func _on_add_environment_obstacle(obstacle_position: Vector2, obstacle_size: Vector2i) -> void:
  var obstacle: PackedVector2Array = _create_obstacle(obstacle_position, obstacle_size)
  if (!_obstacles.has(obstacle)):
    _obstacles.append(obstacle)
  rebake_navigation()

func _on_remove_environment_obstacle(obstacle_position: Vector2, obstacle_size: Vector2i) -> void:
  _obstacles.erase(_create_obstacle(obstacle_position, obstacle_size))
  rebake_navigation()

func _create_obstacle(obstacle_position: Vector2, obstacle_size: Vector2i) -> PackedVector2Array:
  var edge_temper_size_px: int = 1
  var top_left_edge: Vector2 = Vector2(obstacle_position.x, obstacle_position.y)
  var top_right_edge: Vector2 = Vector2(obstacle_position.x + obstacle_size.x, obstacle_position.y)
  var bottom_right_edge: Vector2 = Vector2(obstacle_position.x + obstacle_size.x, obstacle_position.y + obstacle_size.y)
  var bottom_left_edge: Vector2 = Vector2(obstacle_position.x, obstacle_position.y + obstacle_size.y)

  return PackedVector2Array([
    # top-left edge
    Vector2(top_left_edge.x, top_left_edge.y + edge_temper_size_px),
    Vector2(top_left_edge.x + edge_temper_size_px, top_left_edge.y),

    # top-right edge
    Vector2(top_right_edge.x - edge_temper_size_px, top_right_edge.y),
    Vector2(top_right_edge.x, top_right_edge.y + edge_temper_size_px),

    # bottom-right edge
    Vector2(bottom_right_edge.x, bottom_right_edge.y - edge_temper_size_px),
    Vector2(bottom_right_edge.x - edge_temper_size_px, bottom_right_edge.y),

    # bottom-left edge
    Vector2(bottom_left_edge.x + edge_temper_size_px, bottom_left_edge.y),
    Vector2(bottom_left_edge.x, bottom_left_edge.y - edge_temper_size_px),
  ])
