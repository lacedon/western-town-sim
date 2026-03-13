extends Resource
class_name RJob

enum JobTypes {
  OneTime,
  Recurring,
}

## Name of the job that can be used in UI. Should contain an id of a line in translation pack
@export var name: String
## The unit that is assigned to this job
@export var assignee: RUnit = null
@export var type: JobTypes = JobTypes.Recurring
