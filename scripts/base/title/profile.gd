extends Window

# @onready var close_button = get_close_button()

@onready var selected_profile_name = $VBoxContainer/Profiles/VBoxContainer_L/Profile_Name
@onready var selected_profile_game_play_time = $VBoxContainer/Profiles/VBoxContainer_L/Profile_Play_Time

@onready var profile_list = $VBoxContainer/Profiles/VBoxContainer_R/ProfileList

@onready var profile_create_button = $VBoxContainer/crsede/Create
@onready var profile_create_dialog = $ProfileCreateDialog
# @onready var profile_create_dialog_close_button = profile_create_dialog.get_close_button()
# @onready var profile_create_dialog_ok_button = profile_create_dialog.get_ok_button()
# @onready var profile_create_dialog_cancel_button = profile_create_dialog.add_cancel_button("Cancel")
@onready var profile_create_name = $ProfileCreateDialog/LineEdit

@onready var profile_select_button = $VBoxContainer/crsede/Select

@onready var profile_delete_button = $VBoxContainer/crsede/Delete
@onready var profile_delete_dialog = $ProfileDeleteDialog

# TODO: remove this temporary MARGIN_BOTTOM
const MARGIN_TOP: int = 1

func _ready():
	connect("about_to_popup", Callable(self, "list_profiles"))

	# close_button.set_focus_neighbor(MARGIN_BOTTOM, profile_list.get_path())

	profile_list.connect("item_activated", Callable(self, "_on_item_activated"))
	profile_list.connect("item_selected", Callable(self, "_on_item_selected"))

	profile_create_button.connect("pressed", Callable(self, "profile_create_button_pressed"))

	profile_create_dialog.connect("confirmed", Callable(self, "profile_create_dialog_confirmed"))
	profile_create_dialog.connect("popup_hide", Callable(self, "list_profiles"))
	
	profile_create_dialog.register_text_enter(profile_create_name)
	profile_create_dialog.set_wrap_controls(true)
	# profile_create_dialog_ok_button.set_focus_neighbor(MARGIN_TOP, profile_create_name.get_path())
	# profile_create_dialog_cancel_button.set_focus_neighbor(MARGIN_TOP, profile_create_name.get_path())

	profile_create_name.connect("text_changed", Callable(self, "profile_create_name_text_changed"))	

	profile_select_button.connect("pressed", Callable(self, "profile_select_button_pressed"))

	profile_delete_button.connect("pressed", Callable(self, "profile_delete_button_pressed"))
	
	profile_delete_dialog.connect("confirmed", Callable(self, "profile_delete_dialog_confirmed"))
	profile_delete_dialog.connect("popup_hide", Callable(self, "list_profiles"))
	profile_delete_dialog.connect("about_to_popup", Callable(self, "profile_delete_dialog_about_to_show"))
	profile_delete_dialog.connect("focus_entered", Callable(self, "profile_delete_dialog_about_to_show"))
	profile_delete_dialog.set_wrap_controls(true)

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
	profile_create_dialog.popup_centered()
	profile_create_name.clear()
	profile_create_name.grab_focus()

func profile_create_dialog_confirmed():
	if ProfileManager.ProfileErrors.OK == ProfileManager.add_profile(profile_create_name.get_text()):
		profile_create_name.clear()
		list_profiles()

func profile_create_name_text_changed(text):
	profile_create_name.set_text(text.strip_escapes().to_lower().replacen(" ", "_").replacen("/", "_").replacen("\\", "_"))
	profile_create_name.set_caret_column(text.length())
	profile_create_dialog.get_ok_button().set_disabled(text.length() == 0)

func profile_select_button_pressed():
	_on_item_activated(profile_list.get_selected_items()[0])

func profile_delete_button_pressed():
	profile_delete_dialog.set_text("Deleting " + ProfileManager.get_profile_name(profile_list.get_selected_items()[0]) + " profile will permanetly remove settings saved games and screenshots from your system. Are you sure???")
	profile_delete_dialog.popup_centered()

func profile_delete_dialog_about_to_show():
	profile_delete_dialog.get_cancel_button().grab_focus()
	
func profile_delete_dialog_confirmed():
	var deleted_profile = profile_list.get_selected_items()[0]
	ProfileManager.del_profile(deleted_profile)
	list_profiles()
