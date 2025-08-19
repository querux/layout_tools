@tool
class_name LayoutToolsSettings
extends Resource


""" tool tip """
const MENU_TEXT_PACKED: PackedStringArray = ["Layout Tools", "Order Layout"]
const OPTION_MENU_TOOLTIP: String = " Layout Tools "

var _option_label: Label:
	get:
		return _option_label


var _mlayout_id: Dictionary[String, int] = {
	"save_layout"   : 41,
	"delete_layout" : 42,
	"default_layout": 43,
}

var _editor_settings := EditorInterface.get_editor_settings()


################################################################################
#region _sett_res

var _icon_dict: Dictionary = {
	"mono"  : load("res://addons/layout_tools/images/godot_GodotMonochrome.svg"),
	"godo"  : load("res://addons/layout_tools/images/godot_Godot.svg"),
	"grab"  : load("res://addons/layout_tools/images/godot_GuiSliderGrabberHl.svg"),
}

var _item_dict: Dictionary = {
	"order_cont": load("uid://b4gnr8rdsf50d"),
	"name_cont" : load("uid://chagwae15vut7"),
}

var _text_dict: Dictionary = {
	"rich_menu": "[b][  Change Layout order  ][/b]",
}

#endregion
################################################################################
#region _sett_color

func _set_color_value(_color_path: String) -> Color:
	var _color: Color = _editor_settings.get_setting(_color_path)
	return _color

var _color_dict: Dictionary = {
	"accent_color": _set_color_value("interface/theme/accent_color"),
	"bg_color"    : _set_color_value("text_editor/theme/highlighting/background_color"),
}

#endregion
################################################################################
#region _sett_button & stylebox

func _set_label_text(_text: String) -> void:
	_option_label.text = _text


func _set_option_button(_dock_main: LayoutToolsDock) -> void:
	""" button """
	_option_label = Label.new()
	var _menu_width := Vector2(120, 0)
	_dock_main.add_child(_option_label)
	_dock_main.set_anchors_preset(Control.PRESET_FULL_RECT)
	_dock_main.set_custom_minimum_size(_menu_width)
	_dock_main.tooltip_text = OPTION_MENU_TOOLTIP

	_stylebox_theme_override(_dock_main, "normal", 0, 0)
	_stylebox_theme_override(_dock_main, "hover", 0, 0.5)
	_stylebox_theme_override(_dock_main, "focus", 0, 0)

	""" label """
	_set_label_text(MENU_TEXT_PACKED[0])
	_option_label.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_LEFT)
	_option_label.set_vertical_alignment(VERTICAL_ALIGNMENT_CENTER)
	_option_label.set_anchors_preset(Control.PRESET_FULL_RECT)


func _stylebox_theme_override(
	_dock_main: LayoutToolsDock, _style: String, _bg_a: float, _border_a: float
	) -> void:

	var _new_stylebox: StyleBox = _dock_main.get_theme_stylebox(_style).duplicate()
	_new_stylebox.bg_color = Color(0.6, 0.6, 0.6, _bg_a)
	_new_stylebox.border_color = Color(0.8, 0.8, 0.8, _border_a)

	if _border_a > 0:
		var _line_width: int = 1
		_new_stylebox.border_width_left = _line_width
		_new_stylebox.border_width_right = _line_width
		_new_stylebox.border_width_top = _line_width
		_new_stylebox.border_width_bottom = _line_width

	_dock_main.add_theme_stylebox_override(_style, _new_stylebox)

#endregion
################################################################################
#region sett_override_popup_panel

func _set_theme_override_popup_panel(_node: Node) -> void:
	var _stylebox := StyleBoxFlat.new()
	_stylebox.border_color = _color_dict["accent_color"] * 0.75
	_stylebox.bg_color = _color_dict["bg_color"].lightened(0.02)
	_stylebox.border_width_top = 20
	_stylebox.border_width_left = 1
	_stylebox.border_width_right = 1
	_stylebox.border_width_bottom = 1
	_stylebox.corner_radius_bottom_left = 2
	_stylebox.corner_radius_bottom_right = 2
	_node.add_theme_stylebox_override("panel", _stylebox)

func _set_theme_override_margins(_node: Node) -> void:
	_node.add_theme_constant_override("margin_left", 16)
	_node.add_theme_constant_override("margin_right", 16)
	_node.add_theme_constant_override("margin_top", 12)
	_node.add_theme_constant_override("margin_bottom", 12)

#endregion
################################################################################



