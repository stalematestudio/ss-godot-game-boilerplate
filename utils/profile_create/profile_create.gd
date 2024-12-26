class_name ProfileCreateDialog extends ConfirmationDialog

@onready var profile_name_line_edit: LineEdit = $line_edit
@onready var ok_button: Button = get_ok_button()
@onready var cancel_button: Button = get_cancel_button()

@onready var bad_list: PackedStringArray = " ~!@#$%^&*()_+-={}|[]\\:\";',./<>?".split()
@onready var car_col: int

signal profile_create_cancel
signal profile_create_confirm(profile_name: String)

func _ready() -> void:
	close_requested.connect(_on_close_requested)
	cancel_button.pressed.connect(_on_close_requested)
	focus_exited.connect(_on_close_requested)
	profile_name_line_edit.text_changed.connect(_on_line_edit_text_changed)
	ok_button.disabled = true
	ok_button.pressed.connect(_on_ok_button_pressed)
	profile_name_line_edit.grab_focus()
	profile_name_line_edit.focus_next = ok_button.get_path()
	ok_button.set_focus_neighbor(SIDE_TOP, profile_name_line_edit.get_path())
	cancel_button.set_focus_neighbor(SIDE_TOP, profile_name_line_edit.get_path())

func _on_line_edit_text_changed(new_text: String) -> void:
	for bad in bad_list:
		new_text = new_text.replacen(bad, "")
	car_col = profile_name_line_edit.get_caret_column()
	profile_name_line_edit.set_text(new_text.strip_escapes().to_lower().replacen(" ", "_").replacen("/", "_").replacen("\\", "_"))
	profile_name_line_edit.set_caret_column(car_col)
	ok_button.disabled = ( new_text == "" ) || ProfileManager.profile_exists(new_text)

func _on_ok_button_pressed() -> void:
	profile_create_confirm.emit(profile_name_line_edit.get_text())

func _on_close_requested() -> void:
	profile_create_cancel.emit()