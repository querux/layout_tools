@tool
class_name LayoutToolsPlugin
extends EditorPlugin


var _dock_main = LayoutToolsDock.new()

""" class """
var __c: LayoutToolsClassManager


var _base_control: Panel
var _editor_mbar: MenuBar
var _pmenu_editor: PopupMenu
var _pmenu_layout: PopupMenu

var _editor_layout_dialog: Node
var _delete_button: Button


################################################################################
#region setup_init

func _set_class_manager(_setup_class: LayoutToolsClassManager) -> LayoutToolsClassManager:
	if _setup_class == null:
		_setup_class = LayoutToolsClassManager.new()
	return _setup_class

func _set_classes() -> void:
	__c = _set_class_manager(__c)
	__c._plugin = self
	__c._setup_init_lazy()
	__c._setup_arr.push_back(self)

#endregion
################################################################################
#region dock_enter_exit

func _enter_tree() -> void:
	_set_classes()
	_get_editor_node_parts()
	_add_dock_main()

func _exit_tree() -> void:
	if is_instance_valid(_dock_main):
		_remove_dock_main()

#endregion
################################################################################
#region dock_add_remove

func _add_dock_main() -> void:
	__c._setup_settings._set_option_button(_dock_main)
	_add_setup_class()
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, _dock_main)

func _remove_dock_main() -> void:
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, _dock_main)
	_dock_main.queue_free()

func _add_setup_class() -> void:
	_dock_main._setup_class(__c._setup_arr)
	_dock_main._option_label = __c._setup_settings._option_label

#endregion
################################################################################
#region _get_node_parts

func _get_editor_node_parts() -> void:
	_base_control = __c._setup_utility._get_base_control()
	_editor_mbar = __c._setup_utility._find_editor_node(_base_control, &"MenuBar")
	_pmenu_editor = __c._setup_utility._find_get_children(_editor_mbar, "Editor")
	_pmenu_layout = __c._setup_utility._find_get_menu_layout(_pmenu_editor)
	_editor_layout_dialog = __c._setup_utility._get_children_util(_base_control, &"EditorLayoutsDialog")
	_delete_button = _editor_layout_dialog.get_ok_button()
	__c._setup_arr.push_back(_pmenu_layout)

#endregion
################################################################################

