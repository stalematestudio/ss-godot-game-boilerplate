class_name PropsManager extends Node


# func save_data() -> Dictionary:

# 	var game_objects_props: Array = []

# 	for game_object_prop in get_tree().get_nodes_in_group("game_objects_props"):
# 		game_objects_props.append({
# 				"name" : game_object_prop.name,
# 				"scene" : game_object_prop.get_scene_file_path(),
# 				"path" : game_object_prop.get_parent().get_path(),
# 				"object" : var_to_bytes_with_objects(game_object_prop),
# 				})

# 	return {"props": game_objects_props}

# func load_data(props: Dictionary = Dictionary()) -> void:
# 	if game_data.has("props"):
# 		for game_object_prop in get_tree().get_nodes_in_group("game_objects_props"):
# 			game_object_prop.queue_free()
# 		for game_prop in game_data.props:
# 			var game_prop_instance = bytes_to_var_with_objects(Helpers.string_to_packed_byte_array(game_prop.object))
# 			print_debug(game_prop_instance)
# 			game_prop_instance.name = game_prop.name
# 			get_node(game_prop.path).add_child(game_prop_instance)