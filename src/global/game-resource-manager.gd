extends Node

class_name ResourceManager

signal resource_updated(resource: TownResource, value_change: float)
signal max_resource_updated(resource: TownResource, value_change: float)

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

func has_enough_resources(required_resources: Array[TownResource]) -> bool:
  for required_resource in required_resources:
    var is_found: bool = false
    for resource in resources:
      if resource.name == required_resource.name:
        if (resource.value < required_resource.value): return false
        is_found = true
        break
    if !is_found:
      return false
  return true

func use_resources(required_resources: Array[TownResource]) -> bool:
  if !has_enough_resources(required_resources):
    return false
  for required_resource in required_resources:
    for resource in resources:
      if resource.name == required_resource.name:
        resource.value -= required_resource.value
        resource_updated.emit(resource, -required_resource.value)
        break
  return true;
