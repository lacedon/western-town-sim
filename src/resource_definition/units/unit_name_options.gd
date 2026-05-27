extends Resource

class_name UnitNameOptions

@export var is_default: bool = false
@export var first_names: Array[String] = []
@export var last_names: Array[String] = []

func get_name() -> String:
  var first: String = Random.get_random_element(self.first_names)
  var last: String = Random.get_random_element(self.last_names)

  if first == null or last == null: return ""
  return "%s %s" % [first, last]
