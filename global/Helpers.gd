extends Node

func date_time_string() -> String:
	var dt = Time.get_datetime_dict_from_system()
	
	var year = String.num(dt.year)
	var month = String.num(dt.month)
	var day = String.num(dt.day)
	var hour = String.num(dt.hour)
	var minute = String.num(dt.minute)
	var second = String.num(dt.second)
	
	month = month if month.length() == 2 else "0" + month
	day = day if day.length() == 2 else "0" + day
	hour = hour if hour.length() == 2 else "0" + hour
	minute = minute if minute.length() == 2 else "0" + minute
	second = second if second.length() == 2 else "0" + second

	return year + "_" + month + "_" + day + "_" + hour + "_" + minute + "_" + second

func remove_children(p_node: Node) -> void:
	for c_node in p_node.get_children():
		p_node.remove_child(c_node)
		c_node.queue_free()

func button_index_to_button_name(btn_index: int) -> String:
	match btn_index:
		1:
			return "Left mouse button"
		2:
			return "Right mouse button"
		3:
			return "Middle mouse button"
		8:
			return "Extra mouse button 1"
		9:
			return "Extra mouse button 2"
		4:
			return "Mouse wheel up"
		5:
			return "Mouse wheel down"
		6:
			return "Mouse wheel left button"
		7:
			return "Mouse wheel right button"
		_:
			return "Mouse Button Unknown"

func event_as_text(event) -> String:
	var label_text = ''
	if event is InputEventKey:
		label_text = "Key : " + event.as_text()
	# Commented out as the methods don't exist in godot 4.5
	# elif event is InputEventMouseButton:
	# 	label_text = "Mouse Button : " + Helpers.ButtonIndex2ButtonName( event.get_button_index() )
	# 	pass
	# elif event is InputEventJoypadMotion:
	# 	label_text = Input.get_joy_name( InputManager.joypad_device_id ) + ' : ' + Input.get_joy_axis_string( event.axis )
	# 	label_text += ' pos' if event.axis_value > 0 else ' neg'
	# elif event is InputEventJoypadButton:
	# 	label_text = Input.get_joy_name( InputManager.joypad_device_id ) + ' : ' + Input.get_joy_button_string( event.button_index )
	else:
		label_text = event.as_text()
	return label_text

func delete_file(file_path: String, file_name: String) -> void:
	var dir: DirAccess = DirAccess.open(file_path)
	dir.list_dir_begin()
	var element: String = dir.get_next()
	while element:
		if element == file_name:
			print_debug("Remove ", file_path, element, " SUCCESS" if dir.remove(file_path + element) == OK else " FAIL")
			break
		element = dir.get_next()
	dir.list_dir_end()

func recursive_non_empty_dir_deletion(file_path: String) -> void:
	file_path = file_path if file_path.ends_with("/") else file_path + "/"
	var dir: DirAccess = DirAccess.open(file_path)
	dir.list_dir_begin() # TODOConverter3To4 fill missing arguments https://github.com/godotengine/godot/pull/40547
	var element: String = dir.get_next()
	while element:
		if dir.current_is_dir():
			recursive_non_empty_dir_deletion(file_path + element)
		else:
			print_debug("Remove ", file_path, element, " SUCCESS" if dir.remove(file_path + element) == OK else " FAIL")
		element = dir.get_next()
	dir.list_dir_end()
	print_debug("Remove ", file_path, " SUCCESS" if dir.remove(file_path) == OK else " FAIL")

func dictionary_update(dict_a: Dictionary, dict_b: Dictionary) -> void:
	for k in dict_b:
		dict_a[k] = dict_b[k]

func array_difference(array_one: Array, array_two: Array) -> void:
	for item in array_two:
		while item in array_one:
			array_one.remove_at(array_one.find(item))

func list_files(dir_path: String) -> PackedStringArray:
	if DirAccess.dir_exists_absolute(dir_path):
		return DirAccess.open(dir_path).get_files()
	return PackedStringArray()

func string_to_vector(vector_string: String) -> Vector3:
	var float_array: PackedFloat64Array = vector_string.split_floats(',', false)
	print_debug(float_array)
	return Vector3(float_array[0],float_array[1],float_array[2])
