extends Node

var platform
var save_fn
var load_fn
var save_files = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	platform = OS.get_name()
	if platform == "Windows":
		save_fn = Callable(self, "_save_file_win")
		load_fn = Callable(self, "_load_file_win")
	elif platform == "Web":
		save_fn = Callable(self, "_save_file_web")
		load_fn = Callable(self, "_load_file_web")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _get_value_mem(file: int, key: String, default_value=null):
	if !save_files.has(file):
		save_files[file] = {}
	
	if !save_files[file].has(key):
		save_files[file][key] = default_value
	#print("old ", save_files[file][key])
	return save_files[file][key]
	
func _set_value_mem(file: int, key: String, value):
	if !save_files.has(file):
		save_files[file] = {}
	
	#if !save_files[file].has(key):
	save_files[file][key] = value

func get_value(file: int, key: String, default_value=null):
	return _get_value_mem(file, key, default_value)
	
func set_value(file: int, key: String, value):
	_set_value_mem(file, key, value)
	
func _save_file_win(file: int):
	if save_files.has(file):
		var text = JSON.stringify(save_files[file])
		var fd = FileAccess.open("user://save" + str(file) + ".txt", FileAccess.WRITE)
		#print(save_files[file])
		#print("user://save" + str(file) + ".txt")
		fd.store_string(text)

func _load_file_win(file: int):
	if FileAccess.file_exists("user://save" + str(file) + ".txt"):
		var fd = FileAccess.open("user://save" + str(file) + ".txt", FileAccess.READ)
		var text = fd.get_as_text()
		var loaded_data = JSON.parse_string(text)
		save_files[file] = loaded_data
	
func _save_file_web(file: int):
	pass

func _load_file_web(file: int):
	pass
	
func save_file(file: int):
	if save_files.has(file):
		save_fn.call(file)
	
func load_file(file: int):
	load_fn.call(file)
	
func clear_file(file: int):
	save_files[file] = {}
	save_file(file)
