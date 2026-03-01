static func get_random_element(array: Array) -> Variant:
	if array.size() == 0: return null
	return array[randi() % array.size()]
