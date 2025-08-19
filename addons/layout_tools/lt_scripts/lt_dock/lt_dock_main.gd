@tool
class_name LayoutToolsDock
extends OptionButton


""" class """
var __c: LayoutToolsClassManager
var _plugin: LayoutToolsPlugin

var _order_layout_cont: OrderLayoutContainer

var _option_label: Label:
	set(_value):
		_option_label = _value

var _gpopup_menu: PopupMenu
var _self_pmenu: PopupMenu

var _event_button_num: int = -1
var _store_item_id: int = -1
var _store_item_title: String = ""
var _store_layout_data: Dictionary

var _setup_arr: Array
var _layout_id: Dictionary

var _is_ready_delete: bool = false
var _is_click_right: bool = false

var _time: float = 0


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

#endregion
################################################################################
#region _ready_signal

func _set_ready_signals() -> void:
	__c._setup_signal.connect_id_pressed(_gpopup_menu, _on_id_pressed_gmenu)
	__c._setup_signal.connect_button_pressed(_plugin._delete_button, _on_delete_pressed)
	__c._setup_signal.connect_button_toggled(self, _on_button_toggled)
	__c._setup_signal.connect_gui_input(self, _on_gui_input)
	__c._setup_signal.connect_visibility_changed(_order_layout_cont, _on_visibility_changed)

#endregion
################################################################################
#region _ready

func _ready() -> void:
	_instance_popup_container()
	_setup_arr.push_back(_order_layout_cont)
	_order_layout_cont._setup_class(_setup_arr)
	_self_pmenu = self.get_popup()
	_store_layout_data = _get_layout_data()
	_layout_id = __c._setup_settings._mlayout_id
	self.action_mode = BaseButton.ACTION_MODE_BUTTON_RELEASE
	_set_ready_signals.call_deferred()
	_boot_selected_item()
	_set_status()

func _boot_selected_item() -> void:
	var _count: int = _gpopup_menu.item_count
	if _gpopup_menu.item_count > 0:
		for _index: int in range(_count):
			if _gpopup_menu.is_item_checked(_index):
				var _id: int = _gpopup_menu.get_item_id(_index)
				_store_item_id = _id
				break
	_populate_update()
	_poplate_clear()

func _instance_popup_container() -> void:
	if _order_layout_cont == null:
		var _pos: Vector2 = self.get_screen_position()
		var _scene: Resource = __c._setup_settings._item_dict["order_cont"]
		_order_layout_cont = _scene.instantiate()
		self.add_child(_order_layout_cont)
		_order_layout_cont.size = _get_panel_size()
		_order_layout_cont.popup_centered()
		_order_layout_cont.unfocusable = true
		_order_layout_cont.visible = false

func _set_status() -> void:
	self.button_mask = MOUSE_BUTTON_MASK_LEFT | MOUSE_BUTTON_MASK_RIGHT

#endregion
################################################################################


##:: utility
################################################################################
#region _utility

func _is_system_id() -> bool:
	if (_store_item_id == _layout_id["save_layout"] or
		_store_item_id == _layout_id["delete_layout"]
		):
		return true
	return false

func _is_not_system_id(_id: int) -> bool:
	if _id != _layout_id["save_layout"]:
		if _id != _layout_id["delete_layout"]:
			return true
	return false

func _get_moved_after_label_name() -> void:
	var _count: int = _gpopup_menu.item_count
	for i: int in range(_count):
		var _id: int = _gpopup_menu.get_item_id(i)
		var _name: String = _gpopup_menu.get_item_text(i)
		if _name == _store_item_title:
			_store_item_id = _id
			return

""" editor_is_layout_check """
func _geditor_layout_check_init() -> void:
	var _count: int = _gpopup_menu.item_count
	for i: int in range(_count):
		_gpopup_menu.set_item_checked(i, false)

func _geditor_layout_menu(_id: int) -> void:
	var _count: int = _gpopup_menu.item_count
	_geditor_layout_check_init()

	for i: int in range(_count):
		var _gindex: int = _gpopup_menu.get_item_index(_id)
		var _gid: int = _gpopup_menu.get_item_id(_gindex)
		if _gid == _id:
			_gpopup_menu.set_item_checked(_gindex, true)

""" panel_size_position """
func _get_panel_size() -> Vector2:
	var _screen := DisplayServer.screen_get_size()
	var _scale_x: float = 0.15
	var _scale_y: float = 0.3
	var size_x: float = _screen.x * _scale_x
	var size_y: float = _screen.y * _scale_y
	return Vector2(size_x, size_y)

func _set_popup_container_position() -> void:
	var _pos: Vector2 = self.get_screen_position()
	_order_layout_cont.size = _get_panel_size()
	_order_layout_cont.popup_centered()
	_order_layout_cont.position += Vector2i(0, -75)

#endregion
################################################################################


##:: populate
################################################################################
#region handle_poplate

func _populate_update() -> void:
	_store_layout_data = _get_layout_data()
	if _store_item_title != "":
		_get_moved_after_label_name()
	_set_popup_items()
	_update_header_label()

func _poplate_clear() -> void:
	var _popup := self.get_popup()
	if _popup.item_count > 0:
		_update_header_label()
		_popup.clear()

func _update_header_label() -> void:
	if _store_item_id == -1:
		self.select(-1)
		_store_item_title = ""
		__c._setup_settings._set_label_text(__c._setup_settings.MENU_TEXT_PACKED[0])
	else:
		var _index: int = get_item_index(_store_item_id)
		var _title: String = get_item_text(_index)
		select(_index)
		_set_icons(_index, "chk")
		_store_item_title = _title
		_option_label.text = ""

		if _is_system_id():
			_set_icons(_index, "uchk")

func _set_icons(_index: int, _select: String) -> void:
	var _icons: Dictionary = __c._setup_settings._icon_dict
	var _popup := self.get_popup()
	_popup.set_item_as_checkable(_index, false)

	match _select:
		"chk":
			_popup.set_item_icon(_index, _icons["godo"])
			_popup.set_item_icon_modulate(_index, Color.WHITE)
		"uchk":
			_popup.set_item_icon(_index, _icons["mono"])
			var _color := Color(1, 1, 1, 1.0 * 0.25)
			_popup.set_item_icon_modulate(_index, _color)
		"system":
			_popup.set_item_icon(_index, _icons["grab"])
			var _color := Color.SKY_BLUE
			_color.a = 0.5
			_popup.set_item_icon_modulate(_index, _color)
			_popup.set_item_icon_max_width(_index, 12)

#endregion
################################################################################
#region setget_popup_menu

func _get_layout_data() -> Dictionary:
	var _count: int = _gpopup_menu.item_count
	var _temp: Dictionary

	if _gpopup_menu.item_count > 0:
		for i: int in range(_count):
			var _id: int = _gpopup_menu.get_item_id(i)
			var _name: String = _gpopup_menu.get_item_text(i)
			_temp[_id] = _name
	return _temp

func _set_popup_items() -> void:
	var _popup := self.get_popup()
	var _index: int = 0

	for i: int in _store_layout_data:
		var _id: int = i
		var _name: String = _store_layout_data.get(i, "")

		if (i == _layout_id["save_layout"] or
			i == _layout_id["delete_layout"]
			):
			self.add_item(_name, _id)
			_set_icons(_index, "system")
			_index += 1
			continue

		if i == -1:
			self.add_separator()
			_index += 1
			continue

		self.add_item(_name, _id)
		_set_icons(_index, "uchk")
		_index += 1

	var _item_index: int = get_item_index(_store_item_id)
	if _store_item_id != -1:
		_set_icons(_item_index, "chk")

#endregion
################################################################################


##:: signal
################################################################################
#region sig On_connect

func _on_button_toggled(_toggle: bool) -> void:
	if _toggle:
		_populate_update()
		_check_is_connect("connect")

	await get_tree().process_frame

	if not _toggle:
		_poplate_clear()
		_check_is_connect("disconnect")
		_event_button_num = -1


func _on_id_pressed_gmenu(_id: int) -> void:
	if _gpopup_menu.item_count > 0:
		var _index: int = _gpopup_menu.get_item_index(_id)
		var _title: String = _gpopup_menu.get_item_text(_index)
		select(-1)
		_option_label.text = _title
		_store_item_title = _title

		if _id == _layout_id["delete_layout"]:
			_is_ready_delete = true
		if _is_not_system_id(_id):
			_store_item_id = _id


func _on_id_pressed(_id: int) -> void:
	if _self_pmenu.item_count > 0:
		var _index: int = get_item_index(_id)
		_set_icons(_index, "chk")
		select(_index)
		_gpopup_menu.id_pressed.emit(_id)

		if _id == _layout_id["delete_layout"]:
			_is_ready_delete = true

		if _is_not_system_id(_id):
			_geditor_layout_menu(_id)
			_store_item_id = _id
		#prints("id_pressed: ", _id, _store_item_id)

func _on_delete_pressed() -> void:
	if _is_ready_delete:
		_store_item_id = -1
		_update_header_label()
		set_deferred("_is_ready_delete", false)
	set_process(true)
	#print("confirmed")

func _process(_delta: float) -> void:
	_time += _delta
	if _time > 0.4:
		_time = 0
		set_process(false)
		_order_layout_cont._gconf = __c._get_data_editor_layouts_config()

#endregion
################################################################################
#region sig is_connect

func _check_is_connect(_select: String) -> void:
	_self_pmenu = self.get_popup()
	match _select:
		"disconnect":
			if _self_pmenu.is_connected("id_pressed", _on_id_pressed):
				_self_pmenu.disconnect("id_pressed", _on_id_pressed)

		"connect":
			if not _self_pmenu.is_connected("id_pressed", _on_id_pressed):
				__c._setup_signal.connect_id_pressed(_self_pmenu, _on_id_pressed)

#endregion
################################################################################
#region sig gui_input

func _on_gui_input(_event: InputEvent) -> void:
	if _event is InputEventMouseButton:
		if _event.pressed and _event.button_index == MOUSE_BUTTON_LEFT:
			_event_button_num = _event.button_index

		elif _event.pressed and _event.button_index == MOUSE_BUTTON_RIGHT:
			_event_button_num = _event.button_index
			select(-1)
			_order_layout_cont.show()


func _on_visibility_changed() -> void:
	if _order_layout_cont.visible:
		_set_popup_container_position()
		_order_layout_cont._set_layout_menu_items()
		__c._setup_settings._set_label_text(__c._setup_settings.MENU_TEXT_PACKED[1])
	else:
		_event_button_num = -1
		_set_popup_items()
		_update_header_label()
		await get_tree().process_frame
		_poplate_clear()
		self.release_focus.call_deferred()

#endregion
################################################################################

