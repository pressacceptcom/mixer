tool
class_name PressAccept_Mixer_Mixin

# |===========================================|
# |                                           |
# |            Press Accept: Mixer            |
# | Implement Mixin Functionality In GDScript |
# |                                           |
# |===========================================|
#
# This module provides a class for registering and tracking mixin information
#
# Mixins return an instance of this class from
# PressAccept_Mixer_Mixin.STR_MIXABLE_INFO_METHOD (__mixable_info).
# PressAccept_Mixer_Mixer uses this information and its associated code
# generation methods (generate_*) to generate an entire script.
#
# Scripts that are meant to be mixins must be sure to format their mixin
# elements correctly. This is most important currently with methods. The first
# argument to a mixed-in method will be the composite object instance (self).
# In the generated code, this argument is *not* included (it's added in the
# generated code)
#
# One must also be careful of calling mixed-in methods, as they are called using
# .callv, since the call silently fails if the parameters don't match. In the
# calling process, all arguments are set to DefaultArgument by default, then
# eliminated if they are defined (passed) using _trim_defaults(). This allows
# default arguments to be processed correctly by the wrapping mixin script.
#
# |------------------|
# | Meta Information |
# |------------------|
#
# Organization Namespace : PressAccept
# Package Namespace      : Mixer
# Class                  : Mixin
#
# Organization        : Press Accept
# Organization URI    : https://pressaccept.com/
# Organization Social : @pressaccept
#
# Author        : Asher Kadar Wolfstein
# Author URI    : https://wunk.me/ (Personal Blog)
# Author Social : https://incarnate.me/members/asherwolfstein/
#                 @asherwolfstein (Twitter)
#                 https://ko-fi.com/asherwolfstein
#
# Copyright : Press Accept: Typer © 2021 The Novelty Factor LLC
#                 (Press Accept, Asher Kadar Wolfstein)
# License   : Proprietary, All Rights Reserved
#
# |-----------|
# | Changelog |
# |-----------|
#
# 1.0.0    12/20/2021    First Release
#

# ********************
# | Internal Classes |
# ********************

class DefaultArgument:
	extends Reference

# ****************************
# | Private Static Functions |
# ****************************


static func _trim_defaults(
		args: Array) -> Array:

	var filtered: Array = []

	for arg in args:
		if not arg is Object or (arg is Object and arg != DefaultArgument):
			filtered.push_back(arg)

	return filtered


# *********************
# | Public Properties |
# *********************

var identifier   : String

# **********************
# | Private Properties |
# **********************

var _mixin_script : String
var _methods      : Dictionary
var _properties   : Dictionary
var _signals      : Dictionary

# ***************
# | Constructor |
# ***************


# initialize properties, identifier will be used in the composite class
#
# init_mixin_script must be a path to a script file (the mixable script), as
# its used in the generated code. It's also used to verify that any identifiers
# added exist on the script, as well as serve for mixable-mixin differentiation.
# Adding an identifier from a different script than the _mixin_script signals
# that the first argument (_self) shoudld be kept and passed along (see doc)
#
# NOTE: init_* Dictionaries expect dictionaries whose keys are the identifiers
#       ('names') of the referenced get_*_list() dictionaries.
func _init(
		init_identifier   : String,
		init_mixin_script : String,
		init_methods      : Dictionary = {},
		init_properties   : Dictionary = {},
		init_signals      : Dictionary = {}) -> void:

	identifier = init_identifier
	_mixin_script = init_mixin_script
	_methods = init_methods
	_properties = init_properties
	_signals = init_signals


# ******************
# | Public Methods |
# ******************


# indicate a method from a script (default initialized script) is a mixin
#
# NOTE: providing a script != initialized script indicates that it is a mixable
#       method from a mixin itself, an important distinction for arguments
func add_method(
		method_identifier : String,
		script            : String = _mixin_script) -> PressAccept_Mixer_Mixin:

	var script_methods: Dictionary = \
		PressAccept_Typer_ObjectInfo.script_method_info(script)

	if method_identifier in script_methods:
		_methods[method_identifier] = script_methods[method_identifier]

	if script != _mixin_script:
		_methods[method_identifier]['mixin'] = true

	return self


# add multiple methods from a source script
#
# this optimizes the process by only loading the script_method_info once
func add_methods(
		method_identifiers : Array,
		script             : String = _mixin_script) -> PressAccept_Mixer_Mixin:

	var script_methods: Dictionary = \
		PressAccept_Typer_ObjectInfo.script_method_info(script)

	for method_identifier in method_identifiers:
		if method_identifier in script_methods:
			_methods[method_identifier] = script_methods[method_identifier]

	return self


# remove a method by identifier
func remove_method(
		method_identifier: String) -> bool:

	return _methods.erase(method_identifier)


# retrieve the method info dictionary by identifier
func get_method(
		method_identifier: String):

	if _methods.has(method_identifier):
		return _methods[method_identifier]

	return null


# get all method identifiers defined
func get_method_identifiers():

	return _methods.keys()


# indicate a property from a script (default initialized script) is a mixin
func add_property(
		property_identifier : String,
		script              : String = _mixin_script) -> PressAccept_Mixer_Mixin:

	var script_properties: Dictionary = \
		PressAccept_Typer_ObjectInfo.script_property_info(script)

	if property_identifier in script_properties:
		_properties[property_identifier] = script_properties[property_identifier]

	return self


# add multiple properties from a source script
#
# this optimizes the process by only loading the script_property_info once
func add_properties(
		property_identifiers : Array,
		script               : String = _mixin_script
		) -> PressAccept_Mixer_Mixin:

	var script_properties: Dictionary = \
		PressAccept_Typer_ObjectInfo.script_property_info(script)

	for property_identifier in property_identifiers:
		if property_identifier in script_properties:
			_properties[property_identifier] = \
				script_properties[property_identifier]

	return self


# remove a property by identifier
func remove_property(
		property_idenfitier: String) -> bool:

	return _properties.erase(property_idenfitier)


# retrieve the property info dictionary by identifier
func get_property(
		property_identifier: String):

	if _properties.has(property_identifier):
		return _properties[property_identifier]

	return null


# get all property identifiers defined
func get_property_identifiers():

	return _properties.keys()


# indicate a signal from a script (default initialized script) is a mixin
func add_signal(
		signal_identifier : String,
		script            : String = _mixin_script) -> PressAccept_Mixer_Mixin:

	var script_signals: Dictionary = \
		PressAccept_Typer_ObjectInfo.script_signal_info(script)

	if signal_identifier in script_signals:
		_signals[signal_identifier] = script_signals[signal_identifier]

	return self


# add multiple signals from a source script
#
# this optimizes the process by only loading the script_signal_info once
func add_signals(
		signal_identifiers : Array,
		script             : String = _mixin_script) -> PressAccept_Mixer_Mixin:

	var script_signals: Dictionary = \
		PressAccept_Typer_ObjectInfo.script_signal_info(script)

	for signal_identifier in signal_identifiers:
		if signal_identifier in script_signals:
			_signals[signal_identifier] = script_signals[signal_identifier]

	return self


# remove a signal by identifier
func remove_signal(
		signal_identifier: String) -> bool:

	return _signals.erase(signal_identifier)


# retrieve the signal info dictionary by identifier
func get_signal(
		signal_identifier: String):

	if _signals.has(signal_identifier):
		return _signals[signal_identifier]

	return null


# get all signal identifiers defined
func get_signal_identifiers():

	return _signals.keys()


# this method generates the signal definitions
#
# example:
#
# signal(arg0, arg1, arg2)
#
func generate_signals() -> String:

	var source_code: String = ''

	for _signal in _signals:
		_signal = _signals[_signal]
		source_code += "\nsignal " + _signal['name'] + '('
		var arg_num: int = 0
		for arg in _signal['args']:
			if arg.has('name') and arg['name']:
				source_code += arg['name']
			else:
				source_code += 'arg' + str(arg_num)
				arg_num += 1
			source_code += ', '
		source_code = source_code.trim_suffix(', ')
		source_code += ")"

	source_code += "\n"

	return source_code


# this method generates the property definitions
#
# example:
#
# var a_property setget _set_a_property, _get_a_property
#
func generate_properties() -> String:

	var source_code: String = ''

	source_code += "\nvar " + identifier

	for property in _properties:
		property = _properties[property]
		source_code += "\nvar " + property['name'] 
		source_code += ' setget _set_' + property['name']
		source_code += ', _get_' + property['name']

	source_code += "\n"

	return source_code


# this method generates the code that would be in the _init method
#
# this code is used in a mixin wrapper to instantiate the mixed in script as a
# property, identified by identifier, on the wrapper itself as well as connect
# all mixed in signals so that the signal can be passed on
#
# example:
#
# 	identifier = load('_mixin_script').new()
# 	identifier = PressAccept_Mixer_Mixer.instantiate('_mixin_script', [], false)
# 		^- if the mixin is itself a mixin (use_instantiate = true)
#
# 	identifier.connect("signal_name", self, "_on_signal_name")
#
func generate_init(
		use_instantiate: bool = false,
		is_tool: bool = true) -> String:

	var source_code: String = ''

	source_code += "\n\t" + identifier + ' = '
	if not use_instantiate:
		source_code += "load('" + _mixin_script + "').new()"
	else:
		source_code += "PressAccept_Mixer_Mixer.instantiate('"
		source_code += _mixin_script + "', [], "
		source_code += ('true' if is_tool else 'false') + ')' 

	source_code += "\n"

	for _signal in _signals:
		_signal = _signals[_signal]
		source_code += "\n\t" + identifier + '.connect("'
		source_code += _signal['name'] + '", self, '
		source_code += '"_on_' + _signal['name'] + '")'

	source_code += "\n"

	return source_code


# this method wraps up all generated code by defining all necessary methods
#
# this first defines all signal methods (see generate_init), then all property
# methods (see generate_properties) and finally all mixin methods themselves
func generate_methods() -> String:

	var source_code: String = ''

	# generate necessary signal functions
	#
	# each function captures a signal and its args, and then re-emits
	for _signal in _signals:
		_signal = _signals[_signal]
		source_code += "\nfunc _on_" + _signal['name'] + '('

		var arg_num: int = 0
		for arg in _signal['args']:
			if arg.has('name') and arg['name']:
				source_code += "\n\t\t" + arg['name']
			else:
				source_code += "\n\t\targ" + str(arg_num)
				arg_num += 1
			source_code += ','

		source_code = source_code.trim_suffix(',')
		source_code += "):\n\t" + 'emit_signal("' + _signal['name'] + '", '

		arg_num = 0
		for arg in _signal['args']:
			if arg.has('name') and arg['name']:
				source_code += arg['name']
			else:
				source_code += str(arg_num)
				arg_num += 1
			source_code += ', '

		source_code = source_code.trim_suffix(', ')
		source_code += ")\n"

	source_code += "\n"

	# generate necessary property functions
	#
	# mixed in properties will thus get set and read by their access
	for property in _properties:
		property = _properties[property]
		source_code += "\nfunc _set_" + property['name'] + '('
		source_code += "\n\t\tnew_" + property['name'] + '):'
		source_code += "\n\t" + identifier + '.' + property['name'] + ' = '
		source_code += 'new_' + property['name']
		source_code += "\n\nfunc _get_" + property['name'] + '():'
		source_code += "\n\treturn " + identifier + '.' + property['name']
		source_code += "\n"

	# generate all mixin methods
	#
	# if a mixin method is from a mixin, then we alter the arguments to pass
	# on the self parameter appropriately
	for method in _methods:
		method = _methods[method]
		if not method.has('mixin') or not method['mixin']:
			method.args.pop_front()

		source_code += "\nfunc " + method['name'] + "("

		var arg_num: int = 0
		for arg in method['args']:
			if arg.has('name') and arg['name']:
				source_code += "\n\t\t" + arg['name']
			else:
				source_code += '\n\t\targ' + str(arg_num)
				arg_num += 1
			source_code += ' = PressAccept_Mixer_Mixin.DefaultArgument,'
		for arg in method['default_args']:
			if arg.has('name') and arg['name']:
				source_code += "\n\t\t" + arg['name']
			else:
				source_code += '\n\t\targ' + str(arg_num)
				arg_num += 1
			source_code += ' = PressAccept_Mixer_Mixin.DefaultArgument,'

		source_code = source_code.trim_suffix(',')
		source_code += '):'

		# every mixin method should accept one arg: self
		source_code += "\n\tvar args: Array = "
		source_code += 'PressAccept_Mixer_Mixin._trim_defaults(['

		arg_num = 0
		for arg in method['args']:
			if arg.has('name') and arg['name']:
				source_code += arg['name']
			else:
				source_code += 'arg' + str(arg_num)
				arg_num += 1
			source_code += ', '
		for arg in method['default_args']:
			if arg.has('name') and arg['name']:
				source_code += arg['name']
			else:
				source_code += 'arg' + str(arg_num)
				arg_num += 1
			source_code += ', '

		source_code = source_code.trim_suffix(', ')
		source_code += '])'
		if not method.has('mixin') or not method['mixin']:
			source_code += "\n\targs.push_front(self)"
		source_code += "\n\treturn " + identifier + '.callv("' + method['name'] + '"'
		source_code += ', args)'
		
		source_code += "\n"

	return source_code

