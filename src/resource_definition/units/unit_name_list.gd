extends Resource

class_name UnitNameList

const Random = preload("res://src/common/random.gd")

@export var name_options: Array[UnitNameOptions] = []

func get_name() -> String:
  var options := _get_default_options()
  return  "" if options == null else options.get_name()

func _get_default_options() -> UnitNameOptions:
  for options in name_options:
    if options.is_default: return options
  return name_options[0]
