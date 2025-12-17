extends Node

var _emitters: Dictionary = {}
var _listeners: Dictionary = {}

func addEmitter(signalName: String, emitter: Node) -> void:
	if not _emitters.has(signalName): _emitters[signalName] = []

	_emitters[signalName].append(emitter)

	if not _listeners.has(signalName): return
	for listenerMethod in _listeners[signalName]:
		emitter.connect(signalName, listenerMethod)

func removeEmitter(signalName: String, emitter: Node) -> void:
	if not _emitters.has(signalName): return

	var emitterIndex: int = _emitters[signalName].find(emitter)
	if emitterIndex >= 0: _emitters[signalName].pop_at(emitterIndex)

	if !_listeners.has(signalName): return

	for listenerMethod in _listeners[signalName]:
		if emitter.is_connected(signalName, listenerMethod):
			emitter.disconnect(signalName, listenerMethod)

func addListener(signalName: String, method: Callable) -> void:
	if not _listeners.has(signalName): _listeners[signalName] = []
	_listeners[signalName].append(method)

	if not _emitters.has(signalName): return
	for emitter in _emitters[signalName]:
		emitter.connect(signalName, method)

func removeListener(signalName: String, method: Callable) -> void:
	if not _listeners.has(signalName): return

	var listenerIndex: int = _listeners[signalName].find(method)
	if listenerIndex >= 0: _listeners[signalName].pop_at(listenerIndex)

	if not _emitters.has(signalName): return

	for emitter in _emitters[signalName]:
		if emitter.is_connected(signalName, method):
			emitter.disconnect(signalName, method)
