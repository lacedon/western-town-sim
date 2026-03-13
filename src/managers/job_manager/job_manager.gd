@icon("res://assets/icons/manager.svg")

extends Node2D

signal job_added(job: RJob)
signal job_updated(job: RJob)
signal job_deleted(job: RJob)

@abstract class AbstractJobManager:
  @abstract func add_jobs() -> void
  @abstract func remove_jobs() -> void
  @abstract func get_available_jobs() -> void
  @abstract func assign_job() -> void
