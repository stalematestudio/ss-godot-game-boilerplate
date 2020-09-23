extends Popup

onready var profile_name = $PanelContainer/VBoxContainer/HBoxContainer/LineEdit
onready var profile_add_button = $PanelContainer/VBoxContainer/HBoxContainer/Button
onready var profile_list = $PanelContainer/VBoxContainer/HSplitContainer/VBoxContainer_R/ItemList
onready var profile_select_button = $PanelContainer/VBoxContainer/HSplitContainer/VBoxContainer_R/HBoxContainer/Select
onready var profile_delete_button = $PanelContainer/VBoxContainer/HSplitContainer/VBoxContainer_R/HBoxContainer/Delete
onready var confirm_delete_dialog = $ConfirmDeleteDialog

onready var selected_profile_name = $PanelContainer/VBoxContainer/HSplitContainer/VBoxContainer_L/Profile_Name

func _ready():
	connect("about_to_show", self, "_on_about_to_show")
	connect("popup_hide", self, "_on_popup_hide")
	profile_name.connect("text_changed", self, "profile_name_text_changed")
	profile_add_button.connect("pressed", self, "profile_add_button_pressed")
	profile_list.connect("item_activated", self, "_on_item_activated")
	profile_list.connect("item_selected", self, "_on_item_selected")
	profile_select_button.connect("pressed", self, "profile_select_button_pressed")
	profile_delete_button.connect("pressed", self, "profile_delete_button_pressed")
	confirm_delete_dialog.connect("confirmed", self, "confirm_delete_dialog_confirmed")

func _on_about_to_show():
	profile_name.grab_focus()
	list_profiles()

func _on_popup_hide():
	pass

func profile_name_text_changed(text):
	profile_name.set_text(text.strip_escapes().to_lower().replacen(" ", "_").replacen("/", "_").replacen("\\", "_"))
	profile_name.set_cursor_position(text.length())
	profile_add_button.set_disabled(text.length() == 0)

func profile_add_button_pressed():
	if ProfileManager.ProfileErrors.OK == ProfileManager.add_profile(profile_name.get_text()):
		list_profiles()
		profile_name.clear()
		profile_list.grab_focus()

func _on_item_activated(item_index):
	ProfileManager.set_current_profile( item_index )

func _on_item_selected(item_index):
	selected_profile_name.set_text( ProfileManager.get_profile_name(item_index) )
	profile_select_button.set_disabled(false)
	profile_delete_button.set_disabled(false)

func profile_select_button_pressed():
	_on_item_activated(profile_list.get_selected_items()[0])

func profile_delete_button_pressed():
	confirm_delete_dialog.set_text("Deleting " + ProfileManager.get_profile_name(profile_list.get_selected_items()[0]) + " profile will permanetly remove settings saved games and screenshots from your system. Are you sure???")
	confirm_delete_dialog.set_as_minsize()
	confirm_delete_dialog.popup_centered()

func confirm_delete_dialog_confirmed():
	ProfileManager.del_profile(profile_list.get_selected_items()[0])
	list_profiles()

func list_profiles():
	profile_list.clear()
	ProfileManager.get_profile_list()
	for profile in ProfileManager.profile_list:
		profile_list.add_item(profile)
	if profile_list.get_item_count() > 0 :
		profile_list.select(ProfileManager.profile_current)
		_on_item_selected(ProfileManager.profile_current)
