## Transform game tile coordinates into pixels
## @example game_tiles_to_pixels(Vector2(3, 6), Vector2(32, 32)) // Vector2(96, 192)
static func game_tiles_to_pixels(tile_position: Vector2, tile_size: Vector2 = GameConfig.tile_size) -> Vector2:
  return Vector2(
    tile_position.x * tile_size.x,
    tile_position.y * tile_size.y
  )

## Transform pixels into game tile coordinates
## @example pixels_to_game_tiles(Vector2(100, 200), Vector2(32, 32)) // Vector2(3, 6)
static func pixels_to_game_tiles(pixels_position: Vector2, tile_size: Vector2 = GameConfig.tile_size) -> Vector2:
  return Vector2(
    floor(pixels_position.x / tile_size.x),
    floor(pixels_position.y / tile_size.y)
  )

## Transform pixels into game tile coordinates and back
## @example snap_pixels_to_grid(Vector2(100, 200), Vector2(32, 32)) // Vector2(96, 192)
static func snap_pixels_to_grid(pixels_position: Vector2, tile_size: Vector2 = GameConfig.tile_size) -> Vector2:
  return game_tiles_to_pixels(pixels_to_game_tiles(pixels_position, tile_size), tile_size)
