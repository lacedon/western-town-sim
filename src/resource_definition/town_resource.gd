extends Resource

class_name TownResource

@export var name: String
@export var should_show_in_ui: bool
@export var value: float = 0.0
@export var max_value: float = 100.0
## Usage increase the value and the value cannot be higher then max_value
## @example: max capacity of people in town
@export var is_reverted: bool = false

func _init(
  _name: String = self.name,
  _max_value: float = self.max_value,
  _value: float = self.value,
  _is_reverted: bool = self.is_reverted
):
  self.name = _name
  self.max_value = _max_value
  self.value = _value
  self.is_reverted = _is_reverted

func get_copy_with_value(
  _value_overwrite: float = self.value,
) -> TownResource:
  var new_resource: TownResource = TownResource.new(
    self.name,
    self.max_value,
    _value_overwrite,
    self.is_reverted
  )
  return new_resource