extends "../../name_generator.gd"

@export var unit_name_list: UnitNameList

func get_unit_name() -> String:
	if unit_name_list == null: return ""
	return unit_name_list.get_name()
