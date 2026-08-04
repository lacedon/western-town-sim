extends Resource

## Describe the resource to mine in the miner building
class_name MinerResourceDefinition

## The resource to describe
@export var resource: TownResource
@export_range(1, 100, 1, "or_greater") var min_count_for_export: int = 5
@export_range(-1, 100, 1, "or_greater") var max_capacity_to_store: int = 10
@export_range(1., 300., 1., "or_greater") var seconds_to_generate: float = 30.0
