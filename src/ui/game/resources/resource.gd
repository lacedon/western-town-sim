extends PanelContainer

@onready var labelNode: Label = $MarginContainer/HBoxContainer/Label
@onready var labelDividerNode: Label = $MarginContainer/HBoxContainer/LabelDivider
@onready var valueNode: Label = $MarginContainer/HBoxContainer/Value
@onready var valueDividerNode: Label = $MarginContainer/HBoxContainer/ValueDivider
@onready var maxValueNode: Label = $MarginContainer/HBoxContainer/Max

@export var label: String = "Resource"
@export var currentValue: int = 0
@export var maxValue: int = 0
@export var shouldShowMax: bool = true

func _ready() -> void:
  _updateView()

func changeValue(change: int) -> void:
  currentValue += change
  _updateView()

func changeMaxValue(change: int) -> void:
  maxValue += change
  _updateView()

func updateValue(newValue: int) -> void:
  currentValue = newValue
  _updateView()

func updateMaxValue(newValue: int) -> void:
  maxValue = newValue
  _updateView()

func _updateView() -> void:
  if label:
    labelDividerNode.show()
    labelNode.show()
    labelNode.text = label
  else:
    labelDividerNode.hide()
    labelNode.hide()

  valueNode.text = str(currentValue)

  if shouldShowMax:
    valueDividerNode.show()
    maxValueNode.show()
    maxValueNode.text = str(maxValue)
  else:
    valueDividerNode.hide()
    maxValueNode.hide()