extends Node

static func RemoveChildren(p_node):
	for c_node in p_node.get_children():
		p_node.remove_child(c_node)
		c_node.queue_free()

static func ButtonIndex2ButtonName(btn_index):
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

static func event_as_text(event):
	var label_text = ''
	if event is InputEventKey:
		label_text = "Key : " + event.as_text()
	elif event is InputEventMouseButton:
		label_text = "Mouse Button : " + Helpers.ButtonIndex2ButtonName( event.get_button_index() )
	elif event is InputEventJoypadMotion:
		label_text = Input.get_joy_name( InputManager.joypad_device_id ) + ' : ' + Input.get_joy_axis_string( event.axis )
		label_text += ' pos' if event.axis_value > 0 else ' neg'
	elif event is InputEventJoypadButton:
		label_text = Input.get_joy_name( InputManager.joypad_device_id ) + ' : ' + Input.get_joy_button_string( event.button_index )
	else:
		label_text = event.as_text()
	return label_text

func recursive_non_empty_dir_deletion(path):
	path = path if path.ends_with("/") else path + "/"
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin(true, true)
	var el_name = dir.get_next()
	while el_name != "":
		if dir.current_is_dir():
			recursive_non_empty_dir_deletion(path + el_name)
		else:
			dir.remove(path + el_name)
		dir.remove(path)
		el_name = dir.get_next()
	dir.list_dir_end()
