extends ItemList

var job_to_items : Dictionary[RJob, int] = {}

func _ready() -> void:
  StateController.job_manager.job_added.connect(self.add_job)
  StateController.job_manager.job_updated.connect(self.update_job)
  StateController.job_manager.job_deleted.connect(self.delete_job)

func _exit_tree() -> void:
  StateController.job_manager.job_added.disconnect(self.add_job)
  StateController.job_manager.job_updated.disconnect(self.update_job)
  StateController.job_manager.job_deleted.disconnect(self.delete_job)

func add_job(job: RJob) -> void:
  var item_index : int = self.add_item(job.name, null, false)
  self.job_to_items[job] = item_index

func update_job(job: RJob) -> void:
  var item_index : int = self.job_to_items.get(job)
  self.set_item_text(item_index, job.name)

func delete_job(job: RJob) -> void:
  var item_index : int = self.job_to_items.get(job)
  self.remove_item(item_index)
  self.job_to_items.erase(job)
