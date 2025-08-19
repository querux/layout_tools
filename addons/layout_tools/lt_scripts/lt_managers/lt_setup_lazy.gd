@tool
class_name LayoutToolsLazy
extends Resource


################################################################################
#region _lazy_init

func _get_setup_lazy(_setup_lazy: LayoutToolsLazy) -> LayoutToolsLazy:
	if _setup_lazy == null:
		_setup_lazy = LayoutToolsLazy.new()
	return _setup_lazy

func _get_setup_settings(_setup_settings: LayoutToolsSettings) -> LayoutToolsSettings:
	if _setup_settings == null:
		_setup_settings = LayoutToolsSettings.new()
	return _setup_settings

func _get_setup_utility(_setup_utility: LayoutToolsUtility) -> LayoutToolsUtility:
	if _setup_utility == null:
		_setup_utility = LayoutToolsUtility.new()
	return _setup_utility

func _get_setup_signal(_setup_signal: LayoutToolsSignal) -> LayoutToolsSignal:
	if _setup_signal == null:
		_setup_signal = LayoutToolsSignal.new()
	return _setup_signal

################################################################################

