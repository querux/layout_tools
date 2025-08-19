@tool
class_name LayoutToolsUtility
extends Node



################################################################################
#region get_node

func _get_base_control() -> Panel:
	return EditorInterface.get_base_control()

#endregion
################################################################################
#region _find_editor_node

func _find_editor_node(
	_node: Node, _find_class: String, dep: int = 0, d_max: int = 8
	) -> Node:
	if dep > d_max:
		return null
	if _node and _node.is_class(_find_class):
		return _node
	for child in _node.get_children():
		var _found := _find_editor_node(child, _find_class, dep + 1, d_max)
		if _found != null:
			return _found
	return null

func _find_get_children(_node: Node, _find_name: String) -> Node:
	for child in _node.get_children():
		if child is PopupMenu and child.name == _find_name:
			return child
	return null

func _find_get_menu_layout(_node: Node) -> Node:
	var _children: Array[Node] = _node.get_children()
	if not _children.is_empty():
		if _children[-1] is PopupMenu:
			return _children[-1]
	return null

func _get_children_util(_node: Node, _find_name: String) -> Node:
	for child in _node.get_children():
		if child.is_class(_find_name):
			return child
	return null

#endregion
################################################################################

