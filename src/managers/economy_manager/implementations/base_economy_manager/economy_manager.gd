class_name EconomyManager
extends "../../economy_manager.gd"

@export var resources: Array[TownResource] = []

func update_resource(resource_name: String, value_change: float) -> void:
  var found_resource: TownResource = null
  for resource in resources:
    if resource.name == resource_name:
      found_resource = resource
      resource.value += value_change
      break
  if !found_resource:
    found_resource = TownResource.new(resource_name, max(value_change, 0), max(value_change, 0))
    resources.append(found_resource)

  resource_updated.emit(found_resource, value_change)

func update_max_resource(resource_name: String, value_change: float) -> void:
  var found_resource: TownResource = null
  for resource in resources:
    if resource.name == resource_name:
      found_resource = resource
      resource.max_value += value_change
      break
  if !found_resource:
    found_resource = TownResource.new(resource_name, max(value_change, 0), 0)
    resources.append(found_resource)

  max_resource_updated.emit(found_resource, value_change)

func _has_enough_resource_direct(required_resource: TownResource) -> bool:
  var is_found: bool = false
  for resource in resources:
    if resource.name == required_resource.name:
      if (resource.value < required_resource.value): return false
      is_found = true
      break
  if !is_found:
    return false
  return true

func _has_enough_resource_reverted(required_resource: TownResource) -> bool:
  var is_found: bool = false
  for resource in resources:
    if resource.name == required_resource.name:
      if (resource.value + required_resource.value > resource.max_value): return false
      is_found = true
      break
  if !is_found:
    return false
  return true

func has_enough_resource(required_resource: TownResource) -> bool:
  if required_resource.is_reverted: return _has_enough_resource_reverted(required_resource)
  return _has_enough_resource_direct(required_resource)

func has_enough_resources(required_resources: Array[TownResource]) -> bool:
  for required_resource in required_resources:
    var is_enough = has_enough_resource(required_resource)
    if !is_enough: return false
  return true

func _use_resource_with_no_check_direct(required_resource: TownResource) -> void:
  for resource in resources:
    if resource.name == required_resource.name:
      resource.value -= required_resource.value
      resource_updated.emit(resource, -required_resource.value)
      break
  
func _use_resource_with_no_check_reverted(required_resource: TownResource) -> void:
  for resource in resources:
    if resource.name == required_resource.name:
      resource.value += required_resource.value
      resource_updated.emit(resource, required_resource.value)
      break

func _use_resource_with_no_check(required_resource: TownResource) -> void:
  if required_resource.is_reverted: _use_resource_with_no_check_reverted(required_resource)
  else: _use_resource_with_no_check_direct(required_resource)

func use_resources(required_resources: Array[TownResource]) -> bool:
  if !has_enough_resources(required_resources): return false
  for required_resource in required_resources:
    _use_resource_with_no_check(required_resource)
  return true;

func use_resource(required_resource: TownResource) -> bool:
  if !has_enough_resource(required_resource): return false
  _use_resource_with_no_check(required_resource)
  return true;

## Whether `amount` more of the resource can be added without exceeding its max_value.
## Resources not tracked yet are assumed to have no cap.
func has_room_for_resource(resource_name: String, amount: float) -> bool:
  for resource in resources:
    if resource.name == resource_name:
      return resource.value + amount <= resource.max_value
  return true
