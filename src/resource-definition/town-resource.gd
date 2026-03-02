extends Resource

class_name TownResource

@export var name: String
@export var should_show_in_ui: bool
@export var value: float = 0.0
@export var max_value: float = 100.0

func _init(
  _name: String = self.name,
  _max_value: float = self.max_value,
  _value: float = self.value,
):
  self.name = _name
  self.max_value = _max_value
  self.value = _value
