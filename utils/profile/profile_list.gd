extends Window

@export var profile_create_scene: PackedScene = preload("res://utils/profile/profile_create.tscn")
@export var profile_delete_scene: PackedScene = preload("res://utils/profile/profile_delete.tscn")

@onready var selected_profile_name = $VBoxContainer/Profiles/VBoxContainer_L/Profile_Name
@onready var selected_profile_game_play_time = $VBoxContainer/Profiles/VBoxContainer_L/Profile_Play_Time

@onready var profile_list = $VBoxContainer/Profiles/VBoxContainer_R/ProfileList

@onready var profile_create_button = $VBoxContainer/crsede/Create
@onready var profile_select_button = $VBoxContainer/crsede/Select
@onready var profile_delete_button = $VBoxContainer/crsede/Delete

@onready var profile_create_dialog: ProfileCreateDialog

# TODO: remove this temporary MARGIN_BOTTOM
const MARGIN_TOP: int = 1

func _ready():
	about_to_popup.connect(list_profiles)

	# close_button.set_focus_neighbor(MARGIN_BOTTOM, profile_list.get_path())

	profile_list.item_activated.connect(_on_item_activated)
	profile_list.item_selected.connect(_on_item_selected)

	profile_create_button.pressed.connect(profile_create_button_pressed)
	profile_select_button.pressed.connect(profile_select_button_pressed)
	profile_delete_button.pressed.connect(profile_delete_button_pressed)
	
	# profile_create_dialog.register_text_enter(profile_create_name)
	# profile_create_dialog.set_wrap_controls(true)
	# profile_create_dialog_ok_button.set_focus_neighbor(MARGIN_TOP, profile_create_name.get_path())
	# profile_create_dialog_cancel_button.set_focus_neighbor(MARGIN_TOP, profile_create_name.get_path())

	# profile_create_name.text_changed.connect(profile_create_name_text_changed)
	
	# profile_delete_dialog.confirmed.connect(profile_delete_dialog_confirmed)
	# profile_delete_dialog.popup_hide.connect(list_profiles)
	# profile_delete_dialog.about_to_popup.connect(profile_delete_dialog_about_to_show)
	# profile_delete_dialog.focus_entered.connect(profile_delete_dialog_about_to_show)
	# profile_delete_dialog.set_wrap_controls(true)

func list_profiles():
	profile_list.clear()
	ProfileManager.get_profile_list()
	for profile in ProfileManager.profile_list:
		profile_list.add_item(profile)
	if profile_list.get_item_count() > 0 :
		profile_list.select(ProfileManager.profile_current)
		_on_item_selected(ProfileManager.profile_current)
		profile_list.grab_focus()
	else:
		selected_profile_name.set_text( ProfileManager.get_profile_name( ProfileManager.profile_current ) )
		selected_profile_game_play_time.set_text( String.num( ProfileManager.game_play_time ) )
		profile_create_button.grab_focus()
		profile_select_button.set_disabled(true)
		profile_delete_button.set_disabled(true)

func _on_item_activated(item_index):
	ProfileManager.set_profile_current( item_index )

func _on_item_selected(item_index):
	selected_profile_name.set_text( ProfileManager.get_profile_name(item_index) )
	selected_profile_game_play_time.set_text( String.num( ProfileManager.game_play_time ) )
	profile_select_button.set_disabled(false)
	profile_delete_button.set_disabled(false)

func profile_create_button_pressed():
	profile_create_dialog = profile_create_scene.instantiate()
	profile_create_dialog.profile_create_confirm.connect(_on_profile_create_confirm)
	profile_create_dialog.profile_create_cancel.connect(_on_profile_create_cancel)
	add_child(profile_create_dialog)

func _on_profile_create_confirm(profile_name: String):
	if ProfileManager.ProfileErrors.OK == ProfileManager.add_profile(profile_name):
		_on_profile_create_cancel()

func _on_profile_create_cancel():
	profile_create_dialog.profile_create_confirm.disconnect(_on_profile_create_confirm)
	profile_create_dialog.profile_create_cancel.disconnect(_on_profile_create_cancel)
	profile_create_dialog.queue_free()
	list_profiles()

func profile_select_button_pressed():
	_on_item_activated(profile_list.get_selected_items()[0])

func profile_delete_button_pressed():
	# profile_delete_dialog.set_text("Deleting " + ProfileManager.get_profile_name(profile_list.get_selected_items()[0]) + " profile will permanetly remove settings saved games and screenshots from your system. Are you sure???")
	# profile_delete_dialog.popup_centered()
	pass

func profile_delete_dialog_about_to_show():
	# profile_delete_dialog.get_cancel_button().grab_focus()
	pass

func profile_delete_dialog_confirmed():
	var deleted_profile = profile_list.get_selected_items()[0]
	ProfileManager.del_profile(deleted_profile)
	list_profiles()
