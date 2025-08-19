@tool
class_name LayoutNameButton
extends MarginContainer


""" class """
var __c: LayoutToolsClassManager
var _order_layout_cont: OrderLayoutContainer

var _store_layout_id: int
var _store_layout_name: String


@onready var _name_button: Button = %NameButton
@onready var _focus_panel: Panel = %FocusPanel


##:: setup
################################################################################
#region setup_class

func _setup_class(_arr: Array) -> void:
	for item in _arr:
		if item is LayoutToolsClassManager:
			__c = item
		elif item is OrderLayoutContainer:
			_order_layout_cont = item

	_set_ready()
	_set_focus_panel(false)

#endregion
################################################################################
#region _set_ready

func _set_ready() -> void:
	__c._setup_signal.connect_focus_entered(_name_button, _on_focus_entered)

func _on_focus_entered() -> void:
	_order_layout_cont._reset_focus_items()
	_order_layout_cont._selected_focus_item = self
	_set_focus_panel(true)

#endregion
################################################################################
#region set_status

func _set_button_name(_name: String) -> void:
	_name_button.text = _name

func _store_status(_name: String, _id: int) -> void:
	_store_layout_name = _name
	_store_layout_id = _id

func _set_focus_panel(_active: bool) -> void:
	_focus_panel.visible = _active

#endregion
################################################################################

