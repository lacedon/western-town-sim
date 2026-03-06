extends Resource

## Describe the resource to store in the storage
class_name StorageResourceDefinition

## The resource to describe
@export var resource: TownResource
## Max number of the resources in the storage. -1 for no limit
@export_range(-1, 100, 1, "or_greater") var maxCapacity: int = -1
## Default number of resources in building on moment of placing
@export_range(0, 100, 1, "or_greater") var defaultCount: int = 0
