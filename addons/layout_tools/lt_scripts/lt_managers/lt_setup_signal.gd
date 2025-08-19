@tool
class_name LayoutToolsSignal
extends Resource



""" focus_entered_exited """
func connect_focus_entered(_control: Control, _on_focus_entered: Callable) -> void:
	_control.focus_entered.connect(_on_focus_entered)

func connect_focus_exited(_control: Control, _on_focus_exited: Callable) -> void:
	_control.focus_exited.connect(_on_focus_exited)

""" button """
func connect_button_pressed(_button: Button, _on_button_pressed: Callable) -> void:
	_button.pressed.connect(_on_button_pressed)

func connect_button_toggled(_button: Button, _on_button_toggled: Callable) -> void:
	_button.toggled.connect(_on_button_toggled)

""" popup_menu """
func connect_id_pressed(_popup_menu: PopupMenu, _on_id_pressed: Callable) -> void:
	_popup_menu.id_pressed.connect(_on_id_pressed)

""" control """
func connect_gui_input(_control: Control, _on_gui_input: Callable) -> void:
	_control.gui_input.connect(_on_gui_input)

func connect_visibility_changed(_window: Window, _on_visibility_changed: Callable) -> void:
	_window.visibility_changed.connect(_on_visibility_changed)

