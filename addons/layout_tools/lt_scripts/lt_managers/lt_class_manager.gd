@tool
class_name LayoutToolsClassManager


""" class """
var _setup_lazy: LayoutToolsLazy
var _plugin: LayoutToolsPlugin
var _setup_settings: LayoutToolsSettings
var _setup_utility: LayoutToolsUtility
var _setup_signal: LayoutToolsSignal

var _gconf := ConfigFile.new()
var _gconf_path: String

var _setup_arr: Array


################################################################################
#region setup_init

func _get_setup_lazy(_setup_lazy: LayoutToolsLazy) -> LayoutToolsLazy:
	if _setup_lazy == null:
		_setup_lazy = LayoutToolsLazy.new()
	return _setup_lazy

func _setup_init_lazy() -> void:
	_setup_lazy = _get_setup_lazy(_setup_lazy)
	_setup_settings = _setup_lazy._get_setup_settings(_setup_settings)
	_setup_utility = _setup_lazy._get_setup_utility(_setup_utility)
	_setup_signal = _setup_lazy._get_setup_signal(_setup_signal)
	_gconf = _get_data_editor_layouts_config()

	_setup_arr = [
		self, _setup_settings, _setup_utility, _setup_signal,
		_gconf,
	]

#endregion
################################################################################
#region get_editor_layouts.cfg

func _get_data_editor_layouts_config() -> ConfigFile:
	_gconf_path = OS.get_data_dir() + "/Godot/editor_layouts.cfg"

	var _conf := ConfigFile.new()
	var _err: Error = _conf.load(_gconf_path)

	if _err != OK:
		push_warning("Not exist saved layout data: %s" % _gconf_path)
		return null
	return _conf

func _get_config_data_editor_layouts(_conf: ConfigFile) -> Dictionary:
	var _temp: Dictionary[String, Dictionary]

	for sec in _conf.get_sections():
		for key in _conf.get_section_keys(sec):
			if not _temp.has(sec):
				_temp[sec] = {}
			_temp[sec][key] = _conf.get_value(sec, key)

	return _temp

#endregion
################################################################################

