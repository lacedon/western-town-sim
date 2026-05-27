extends "../../name_generator.gd"

@export var unit_name_list: UnitNameList

func generate_name() -> String:
	if unit_name_list == null: return ""
	return unit_name_list.generate_name()
