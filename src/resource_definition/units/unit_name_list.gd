extends Resource

class_name UnitNameList

@export var name_options: Array[UnitNameOptions] = []

func generate_name() -> String:
  var options := _get_default_options()
  return  "" if options == null else options.generate_name()

func _get_default_options() -> UnitNameOptions:
  for options in name_options:
    if options.is_default: return options
  return name_options[0]
