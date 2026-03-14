extends "../../job_manager.gd"

var jobs: Array[RJob] = []

func add_job(job: RJob) -> void:
  jobs.append(job)
  self.job_added.emit(job)

func add_jobs(jobs_to_add: Array[RJob]) -> void:
  for job in jobs_to_add:
    add_job(job)

func remove_job(job: RJob) -> void:
  jobs.erase(job)
  self.job_deleted.emit(job)

func remove_jobs(jobs_to_remove: Array[RJob]) -> void:
  for job in jobs_to_remove:
    remove_job(job)

func assign_job(job: RJob, unit: RUnit) -> void:
  job.assignee = unit
  self.job_updated.emit(job)

func is_job_available(job: RJob) -> bool:
  return job.assignee == null

func get_all_jobs() -> Array[RJob]:
  return jobs

func get_available_jobs() -> Array[RJob]:
  return jobs.filter(is_job_available)
