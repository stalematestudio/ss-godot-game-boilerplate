extends Popup

onready var profile_name = $PanelContainer/VBoxContainer/HBoxContainer/LineEdit
onready var profile_add_button = $PanelContainer/VBoxContainer/HBoxContainer/Button
onready var profile_list = $PanelContainer/VBoxContainer/HSplitContainer/VBoxContainer_R/ItemList
onready var profile_select_button = $PanelContainer/VBoxContainer/HSplitContainer/VBoxContainer_R/Button

func _ready():
	connect("about_to_show", self, "_on_about_to_show")
	connect("popup_hide", self, "_on_popup_hide")

func _on_about_to_show():
	profile_name.grab_focus()
	list_profiles()

func _on_popup_hide():
	pass

func list_profiles():
	profile_list.clear()
	ProfileManager.get_profile_list()
	print(ProfileManager.profile_list)
	for profile in ProfileManager.profile_list:
		profile_list.add_item(profile)
