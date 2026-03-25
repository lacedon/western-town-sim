extends Resource

class_name RBuilding

enum BuildingMode {
  normal,
  chaining,
  rect,
}

func _init(
  _name: String = self.name,
  _size: Vector2i = self.size,
  _texture: Texture2D = self.texture,
  _building_mode: BuildingMode = self.building_mode,
  _functions: Array[BuildingFunction] = self.functions,
  _entrances: Array[Vector2] = self.entrances,
  _position_tiles: Vector2 = self.position_tiles
):
  self.name = _name
  self.size = _size
  self.texture = _texture
  self.building_mode = _building_mode
  self.functions = _functions
  self.entrances = _entrances
  self.position_tiles = _position_tiles

@export var name: String = ":: Building ::"
@export var size: Vector2i = Vector2i.ONE
@export var building_mode: BuildingMode = BuildingMode.normal
@export var texture: Texture2D
@export var functions: Array[BuildingFunction] = []
## Array of game tile coordinates for each entrance in the building
@export var entrances: Array[Vector2] = []
## Position of the building in game tile coordinates
@export var position_tiles: Vector2 = Vector2.ZERO

func clone() -> RBuilding:
  return RBuilding.new(
    self.name,
    self.size,
    self.texture.duplicate(),
    self.building_mode,
    self.functions,
    self.entrances.duplicate(),
    self.position_tiles,
  )

func clone_at(_new_position_tiles: Vector2) -> RBuilding:
  var cloned: RBuilding = clone()
  cloned.position_tiles = _new_position_tiles
  return cloned

func on_building_placed() -> void:
  for function in functions:
    function.on_building_placed(self)

func on_building_destroyed() -> void:
  for function in functions:
    function.on_building_destroyed(self)

func on_day_change(position: Vector2) -> void:
  for function in functions:
    function.on_day_change(self, position)

func get_entrace_position() -> Vector2:
  var entrance: Vector2 = self.entrances.pick_random()
  return Vector2(
    entrance.x * GameConfig.tile_size.x,
    entrance.y * GameConfig.tile_size.y
  ) # + node position ???
