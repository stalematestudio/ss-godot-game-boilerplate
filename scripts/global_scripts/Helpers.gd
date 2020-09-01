extends Node

static func RemoveChildren(p_node):
	for c_node in p_node.get_children():
		p_node.remove_child(c_node)
		c_node.queue_free()
