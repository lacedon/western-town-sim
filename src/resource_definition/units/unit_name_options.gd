extends Resource

class_name UnitNameOptions

@export var is_default: bool = false
@export var first_names: Array[String] = []
@export var last_names: Array[String] = []

func generate_name() -> String:
  var first: String = self.first_names.pick_random()
  var last: String = self.last_names.pick_random()

  if first == null or last == null: return ""
  return "%s %s" % [first, last]
