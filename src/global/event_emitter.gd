extends Node

signal event(signal_name: String, data: Variant)

var event_name = event.get_name()

var _emitters: Dictionary[String, Array] = {}
var _listeners: Dictionary[String, Array] = {}

func _ready():
	add_emitter(self.event_name, self)

func emit_event(signal_name: String, data: Variant = null) -> void:
	self.event.emit(signal_name, data)

func add_emitter(signal_name: String, emitter: Object) -> void:
	if not _emitters.has(signal_name): _emitters[signal_name] = []

	_emitters[signal_name].append(emitter)

	if not _listeners.has(signal_name): return
	for listener_method in _listeners[signal_name]:
		emitter.connect(signal_name, listener_method)

func remove_emitter(signal_name: String, emitter: Object) -> void:
	if not _emitters.has(signal_name): return

	var emitter_index: int = _emitters[signal_name].find(emitter)
	if emitter_index >= 0: _emitters[signal_name].pop_at(emitter_index)

	if !_listeners.has(signal_name): return

	for listener_method in _listeners[signal_name]:
		if emitter.is_connected(signal_name, listener_method):
			emitter.disconnect(signal_name, listener_method)

func add_listener(signal_name: String, method: Callable) -> void:
	if not _listeners.has(signal_name): _listeners[signal_name] = []
	_listeners[signal_name].append(method)

	if not _emitters.has(signal_name): return
	for emitter in _emitters[signal_name]:
		emitter.connect(signal_name, method)

func remove_listener(signal_name: String, method: Callable) -> void:
	if not _listeners.has(signal_name): return

	var listenerIndex: int = _listeners[signal_name].find(method)
	if listenerIndex >= 0: _listeners[signal_name].pop_at(listenerIndex)

	if not _emitters.has(signal_name): return

	for emitter in _emitters[signal_name]:
		if emitter.is_connected(signal_name, method):
			emitter.disconnect(signal_name, method)
