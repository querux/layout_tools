@tool
class_name OrderLayoutContainer
extends PopupPanel


""" class """
var __c: LayoutToolsClassManager
var _plugin: LayoutToolsPlugin

var _selected_focus_item: LayoutNameButton

var _gconf: ConfigFile
var _gconf_path: String


var _gpopup_menu: PopupMenu
var _layout_id: Dictionary
var _setup_arr: Array

var _store_omit_item_dict: Dictionary
var _store_l_items_dict: Dictionary
var _layout_config_dict: Dictionary[String, Dictionary]


@onready var _rich_text: RichTextLabel = %RichTextLabel
@onready var _mcontainer: MarginContainer = %MContainer
@onready var _vbox: VBoxContainer = %VBox
@onready var _move_up: Button = %ButtonMoveUP
@onready var _move_down: Button = %ButtonMoveDOWN


##:: setup
################################################################################
#region setup_class

func _setup_class(_arr: Array) -> void:
	_setup_arr = _arr

	for item in _arr:
		if item is LayoutToolsClassManager:
			__c = item
		elif item is LayoutToolsPlugin:
			_plugin = item
		elif item is PopupMenu:
			_gpopup_menu = item
		elif item is ConfigFile:
			_gconf = item

	_set_ready()
	_init_vbox_children()
	_gconf_path = __c._gconf_path

#endregion
################################################################################
#region _ready_signal

func _set_ready_signals() -> void:
	__c._setup_signal.connect_button_pressed(_move_up, _on_move_up_pressed)
	__c._setup_signal.connect_button_pressed(_move_down, _on_move_down_pressed)

#endregion
################################################################################
#region _ready

func _set_ready() -> void:
	_layout_id = __c._setup_settings._mlayout_id
	__c._setup_settings._set_theme_override_popup_panel(self)
	__c._setup_settings._set_theme_override_margins(_mcontainer)
	_rich_text.text = __c._setup_settings._text_dict["rich_menu"]
	_set_ready_signals.call_deferred()

#endregion
################################################################################


##:: container_item
################################################################################
#region init_container

func _reset_focus_items() -> void:
	for _button: LayoutNameButton in _vbox.get_children():
		_button._set_focus_panel(false)

func _init_vbox_children() -> void:
	for child in _vbox.get_children():
		child.queue_free()

#endregion
################################################################################
#region set_cont_items

func _set_layout_menu_items() -> void:
	_init_vbox_children()
	var _count: int = _gpopup_menu.item_count
	var _res_dict: Dictionary = __c._setup_settings._item_dict

	for i: int in range(_count):
		var _id: int = _gpopup_menu.get_item_id(i)
		var _name: String = _gpopup_menu.get_item_text(i)

		if (_id == _layout_id["save_layout"] or
			_id == _layout_id["delete_layout"] or
			_id == _layout_id["default_layout"]):
			_store_omit_item_dict[_id] = _name
			continue

		if _id == -1:
			_store_omit_item_dict[_id] = ""
			continue
		var _name_cont: LayoutNameButton = _res_dict["name_cont"].instantiate()
		_vbox.add_child(_name_cont)
		_name_cont._setup_class(_setup_arr)
		_name_cont._set_button_name(_name)
		_name_cont._store_status(_name, _id)

#endregion
################################################################################
#region handle_rebuild

func _handle_rebuild() -> void:
	if _gconf == null:
		push_error("Please Reboot the layout tools.: %s" % _gconf_path)
		return

	_store_l_items_dict = _rebuild_item_status()
	_layout_config_dict = __c._get_config_data_editor_layouts(_gconf)
	_rebuild_data_config(_layout_config_dict)
	_rebuild_editor_layout_items()

func _rebuild_item_status() -> Dictionary:
	var _temp: Dictionary
	var _first_id: int = 4
	for child: LayoutNameButton in _vbox.get_children():
		child._store_layout_id = _first_id
		_temp[child._store_layout_id] = child._store_layout_name
		_first_id += 1
	return _temp

func _rebuild_data_config(_conf_dict: Dictionary) -> void:
	var _reorder_l_items: Dictionary[String, Dictionary]
	_gconf.clear()

	for i: int in _store_l_items_dict:
		for key: String in _conf_dict:
			if _store_l_items_dict[i] == key:
				_reorder_l_items[key] = _conf_dict[key]

	## rebuild_saving
	for key: String in _reorder_l_items:
		var _section: String = key

		for _dkey: String in _reorder_l_items[key]:
			var _value: Variant = _reorder_l_items[key][_dkey]
			_gconf.set_value(_section, _dkey, _value)

	_gconf.save(_gconf_path)

func _rebuild_editor_layout_items() -> void:
	var _count: int = _gpopup_menu.item_count

	for i: int in range(_count):
		var _id: int = _gpopup_menu.get_item_id(i)

		if (_id == -1 or
			_id == _layout_id["save_layout"] or
			_id == _layout_id["delete_layout"] or
			_id == _layout_id["default_layout"]
			):
			continue

		if i >= 4:
			var _name: String = _store_l_items_dict.get(i, "")
			if _name != "":
				_gpopup_menu.set_item_text(i, _name)
				_gpopup_menu.set_item_id(i, _id)

#endregion
################################################################################
#region sig move_up_down

func _on_move_up_pressed() -> void:
	if _selected_focus_item:
		var _index: int = _selected_focus_item.get_index()
		if _index > 0:
			_selected_focus_item.get_parent().move_child(_selected_focus_item, _index -1)
		_handle_rebuild()

func _on_move_down_pressed() -> void:
	if _selected_focus_item:
		var _index: int = _selected_focus_item.get_index()
		if _index < _vbox.get_child_count():
			_selected_focus_item.get_parent().move_child(_selected_focus_item, _index +1)
		_handle_rebuild()

#endregion
################################################################################

