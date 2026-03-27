@icon("res://assets/icons/manager.svg")

@abstract 
extends Node

signal job_added(job: RJob)
signal job_updated(job: RJob)
signal job_deleted(job: RJob)

@abstract func add_job(job: RJob) -> void
@abstract func add_jobs(jobs: Array[RJob]) -> void
@abstract func remove_job(job: RJob) -> void
@abstract func remove_jobs(jobs: Array[RJob]) -> void
@abstract func assign_job(job: RJob, unit: RUnit) -> void
@abstract func get_all_jobs() -> Array[RJob]
@abstract func get_available_jobs() -> Array[RJob]
@abstract func get_available_job() -> RJob
