extends PanelContainer

@onready var _label_node: Label = $MarginContainer/HBoxContainer/Label
@onready var _label_divider_node: Label = $MarginContainer/HBoxContainer/LabelDivider
@onready var _value_node: Label = $MarginContainer/HBoxContainer/Value
@onready var _value_divider_node: Label = $MarginContainer/HBoxContainer/ValueDivider
@onready var _max_value_node: Label = $MarginContainer/HBoxContainer/Max

@export var label: String = "Resource"
@export var current_value: int = 0
@export var max_value: int = 0
@export var should_show_max: bool = true
@export var resource: TownResource

func _ready() -> void:
  _update_view()

func update_value(change: int) -> void:
  set_value(current_value + change)

func update_max_value(change: int) -> void:
  set_max_value(max_value + change)

func set_value(newValue: int) -> void:
  current_value = newValue
  _update_view()

func set_max_value(newValue: int) -> void:
  max_value = newValue
  _update_view()

func _update_view() -> void:
  if label:
    _label_divider_node.show()
    _label_node.show()
    _label_node.text = label
  else:
    _label_divider_node.hide()
    _label_node.hide()

  _value_node.text = str(current_value)

  if should_show_max:
    _value_divider_node.show()
    _max_value_node.show()
    _max_value_node.text = str(max_value)
  else:
    _value_divider_node.hide()
    _max_value_node.hide()