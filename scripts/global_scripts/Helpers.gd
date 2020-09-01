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
