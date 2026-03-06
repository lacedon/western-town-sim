extends Resource

## Describe the resource to mine in the miner building
class_name MinerResourceDefinition

## The resource to describe
@export var resource: TownResource
@export_range(1, 100, 1, "or_greater") var minCountForExport: int = 1
@export_range(-1, 100, 1, "or_greater") var maxCapacityToStore: int = 10
@export_range(0., 10., 0.25, "or_greater") var resourcesPerTick: float = 0.25
