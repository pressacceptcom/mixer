tool
class_name PressAccept_Mixer_Mixer

# |===========================================|
# |                                           |
# |            Press Accept: Mixer            |
# | Implement Mixin Functionality In GDScript |
# |                                           |
# |===========================================|
#
# This module provides functions to implement mixin functinality in GDScript
#
# In Godot, every Object/Script can have no more than a single parent. This
# creates a situation where object composition is relegated to a declarative
# process using nodes and a node tree.
#
# However, even if a given object is providing common functionality to a parent
# or sibling node, the functionality must always still be referenced via the
# object itself. One might place an instance of the object, or it's Script, in
# a property of another Script or Object that uses it, but any method calls
# must still be referenced through that property/constant. GDScript offers no
# functionality for dynamic method calls, only dynamic property access, which
# means there's no real way to elevate methods into a parent object without
# relying on FuncRefs and indirect function call methods.
#
# This module tries to remedy this by dynamically constructing wrapper Scripts
# given information about a given type's mixin settings. In this way, we can
# specify another script as a property, and then 'elevate' that script's
# specific methods into the enclosing Script by dynamically creating functions
# that reference that property. 
#
# |------------------|
# | Meta Information |
# |------------------|
#
# Organization Namespace : PressAccept
# Package Namespace      : Mixer
# Class                  : Mixer
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
# 2.0.0    12/21/2021    Opted to pass self into _init to be stored as property
#                            rather than pass self to each mixin method
# 2.1.0    12/29/2021    Removed _normalize_script, use ObjectInfo.normalize_script
#                        Added support for dependencies
#                        Added support for method overriding
#                        Added Script Cache (DICT Constant)
#                        Added support for __init and default _init arguments

# *************
# | Constants |
# *************

# name of the method that gives us the info on how to mix this script
const STR_MIXABLE_INFO_METHOD : String = '__mixable_info'
# name of the method that gives us the info on how to composite this script
const STR_MIXED_INFO_METHOD   : String = '__mixed_info'

const DICT_SCRIPT_CACHE       : Dictionary = {}

# ***************************
# | Public Static Functions |
# ***************************


# tests whether we can extract mixable info from a class
static func is_mixable(
		type) -> bool:

	return PressAccept_Typer_ObjectInfo	\
		.script_has_method(type, STR_MIXABLE_INFO_METHOD)


# tests whether we can extract composite info from a class
static func is_mixed(
		type) -> bool:

	return PressAccept_Typer_ObjectInfo \
		.script_has_method(type, STR_MIXED_INFO_METHOD)


# instantiate an object (possibly mixin)
#
# returns a string with an error message on failure
#
# NOTE: type can be String (resource path) or Script object
static func generate_script(
		type,                     # String | Script
		is_tool   : bool = true): # -> String | Object

	type = PressAccept_Typer_ObjectInfo.normalize_script(type)

	if not PressAccept_Typer_ObjectInfo. \
				script_has_method(type, STR_MIXED_INFO_METHOD) \
			or not type.resource_path:
		# nothing to/can mix, just return the original script
		return type

	if type.resource_path in DICT_SCRIPT_CACHE:
		return DICT_SCRIPT_CACHE[type.resource_path]

	# determine the mixins, and how to instantiate them
	var mixed_info      : Array = type.call(STR_MIXED_INFO_METHOD)
	var resolved_mixins : Dictionary = {}

	var additions: Array = mixed_info
	while mixed_info:
		var next_additions: Array = []
		for mixin in mixed_info:
			mixin = PressAccept_Typer_ObjectInfo.normalize_script(mixin)
			if mixin is Script and mixin.resource_path:
				if is_mixable(mixin):
					resolved_mixins[mixin.resource_path] = \
						{
							'info': mixin.call(STR_MIXABLE_INFO_METHOD)
						}
					if PressAccept_Typer_ObjectInfo.object_has_property(
								resolved_mixins[mixin.resource_path]['info'],
								'requires'
							):
						var requirements: Array = \
							resolved_mixins[mixin \
								.resource_path]['info'].requires
						if requirements:
							for requirement in requirements:
								if not requirement in additions:
									additions.push_back(requirement)
									next_additions.push_back(requirement)
				else:
					# it's not mixable, so ignore it
					continue

				if is_mixed(mixin):
					# the mixin is itself a mixed object
					# set it to use instantiate
					resolved_mixins[mixin.resource_path]['instantiate'] = true
				else:
					resolved_mixins[mixin.resource_path]['instantiate'] = false
		mixed_info = next_additions

	# check if identifiers are unique
	var identifiers  : Array = []
	var signals      : Array = \
		PressAccept_Typer_ObjectInfo.script_signal_info(type).keys()
	var properties   : Array = \
		PressAccept_Typer_ObjectInfo.script_property_info(type).keys()
	var type_methods : Array = \
		PressAccept_Typer_ObjectInfo.script_method_info(type).keys()
	var methods      : Array = \
		PressAccept_Typer_ObjectInfo.script_method_info(type).keys()
	for mixin in resolved_mixins:
		mixin = resolved_mixins[mixin]['info']
		if not mixin.identifier in identifiers:
			identifiers.push_back(mixin.identifier)
		else:
			return 'Error: Duplicate Mixin Identifiers - "' \
				+ mixin.identifier + '"'
		for _signal in mixin.get_signal_identifiers():
			if not _signal in signals:
				signals.push_back(_signal)
			else:
				return 'Error: Duplicate Signal Identifiers - "' + _signal + '"'
		for property in mixin.get_property_identifiers():
			if not property in properties:
				properties.push_back(property)
			else:
				return 'Error: Duplicate Property Identifiers - "' \
					+ property + '"'
		for method in mixin.get_method_identifiers():
			if not method in methods:
				methods.push_back(method)
			else:
				if method in type_methods:
					mixin.remove_method(method) # we're overriding this method
				else:
					return \
						'Error: Duplicate Method Identifiers - "' + method + '"'

	# begin generating source code
	var source_code: String = "tool\n" if is_tool else ''
	source_code += "extends '" + type.resource_path + "'\n\n"

	# generate signals
	for mixin in resolved_mixins:
		mixin = resolved_mixins[mixin]['info']
		source_code += mixin.generate_signals()

	# generate properties
	for mixin in resolved_mixins:
		mixin = resolved_mixins[mixin]['info']
		source_code += mixin.generate_properties()

	# generate _init
	source_code += "\nfunc _init("
	var __init_args   : String = ''
	var num_init_args : int = 0
	if not is_mixable(type):
		if PressAccept_Typer_ObjectInfo.script_has_method(type, '__init'):
			var __init: Dictionary = \
				PressAccept_Typer_ObjectInfo.script_method_info(type)['__init']
			num_init_args = \
				__init['args'].size() + __init['default_args'].size()
			for arg in range(num_init_args):
				__init_args += 'arg' + str(arg) \
					+ ' = PressAccept_Mixer_Mixin.DefaultArgument, '
			__init_args = __init_args.trim_suffix(', ')
		else:
			var _init: Dictionary = \
				PressAccept_Typer_ObjectInfo.script_method_info(type)['_init']
			var _num_args: int = \
				_init['args'].size() + _init['default_args'].size()
			__init_args = ''
			for arg in range(_num_args):
				__init_args += 'arg' + str(arg) + ', '
			__init_args = __init_args.trim_suffix(', ')
		source_code += __init_args + ')'
		if PressAccept_Typer_ObjectInfo.script_has_method(type, '_init'):
			var _init: Dictionary = \
				PressAccept_Typer_ObjectInfo.script_method_info(type)['_init']
			var _num_args: int = \
				_init['args'].size() + _init['default_args'].size()
			var _init_args: String = ''
			for arg in range(_num_args):
				_init_args += 'arg' + str(arg) + ', '
			_init_args = _init_args.trim_suffix(', ')
			source_code += '.(' + _init_args + ')'
		source_code += " -> void:\n"
	else:
		source_code += "arg0).(arg0) -> void:\n"

	for mixin in resolved_mixins:
		mixin = resolved_mixins[mixin]
		if not is_mixable(type):
			source_code += \
				mixin['info'].generate_init(mixin['instantiate'], is_tool)
		else:
			source_code += \
				mixin['info'].generate_init(
					mixin['instantiate'],
					is_tool,
					'arg0'
				)

	if num_init_args:
		source_code += "\n\tif has_method('__init'):"
		source_code += "\n\t\tvar args: Array = " \
			+ 'PressAccept_Mixer_Mixin._trim_defaults(['
		var args: String = ''
		for arg in range(num_init_args):
			args += 'arg' + str(arg) + ', '
		args = args.trim_suffix(', ')
		source_code += args + "])\n"
		source_code += "\n\t\tself.callv('__init', args)\n"

	# generate wrapper methods
	for mixin in resolved_mixins:
		mixin = resolved_mixins[mixin]['info']
		source_code += mixin.generate_methods()

	# instantiate our wrapper oobject
	var generated_script = GDScript.new()
	generated_script.source_code = source_code
	generated_script.reload()

	# store in cache
	DICT_SCRIPT_CACHE[type.resource_path] = generated_script

	return generated_script


static func instantiate(
		type,                     # String | Script
		init_args : Array,
		is_tool   : bool = true): # -> String | Object

	var generated_script = generate_script(type, is_tool)

	if generated_script is Script:
		return generated_script.callv('new', init_args)

	return null

