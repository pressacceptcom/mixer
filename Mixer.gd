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
#

# *************
# | Constants |
# *************

# name of the method that gives us the info on how to mix this script
const STR_MIXABLE_INFO_METHOD : String = '__mixable_info'
# name of the method that gives us the info on how to composite this script
const STR_MIXED_INFO_METHOD   : String = '__mixed_info'

# ****************************
# | Private Static Functions |
# ****************************


# normalize a given input (path name) to a Script resource object
static func _normalize_script(
		script) -> Script:

	if script is String:
		if script.begins_with('res://'):
			return load(script) as Script

	if not script is Script:
		return null

	return script


# ***************************
# | Public Static Functions |
# ***************************


# tests whether we can extract mixable info from a class
static func is_mixable(
		type) -> bool:

	type = _normalize_script(type)
	if not type is Script or not type.resource_path:
		return false

	if PressAccept_Typer_Typer.script_has_method(type, STR_MIXABLE_INFO_METHOD):
		return true

	return false


# tests whether we can extract composite info from a class
static func is_mixed(
		type) -> bool:

	type = _normalize_script(type)
	if not type is Script or not type.resource_path:
		return false

	if PressAccept_Typer_Typer.script_has_method(type, STR_MIXED_INFO_METHOD):
		return true

	return false


# instantiate an object (possibly mixin)
#
# returns a string with an error message on failure
#
# NOTE: type can be String (resource path) or Script object
static func generate_script(
		type,                     # String | Script
		init_args : Array,
		is_tool   : bool = true): # -> String | Object

	type = _normalize_script(type)
	if not type is Script or not type.resource_path:
		return null

	if not PressAccept_Typer_ObjectInfo. \
			script_has_method(type, STR_MIXED_INFO_METHOD):
		# nothing to mix, just return the original script
		return type

	# determine the mixins, and how to instantiate them
	var mixed_info      : Array = type.call(STR_MIXED_INFO_METHOD)
	var resolved_mixins : Dictionary = {}
	for mixin in mixed_info:
		mixin = _normalize_script(mixin)
		if mixin is Script \
				and mixin.resource_path:
			if PressAccept_Typer_ObjectInfo.script_has_method(
						mixin,
						STR_MIXABLE_INFO_METHOD
					):
				resolved_mixins[mixin.resource_path] = \
					{
						'info': mixin.call(STR_MIXABLE_INFO_METHOD)
					}
			else:
				# it's not mixable, so ignore it
				continue

			if PressAccept_Typer_ObjectInfo.script_has_method(
						mixin,
						STR_MIXED_INFO_METHOD
					):
				# the mixin is itself a mixed object
				# set it to use instantiate
				resolved_mixins[mixin.resource_path]['instantiate'] = true
			else:
				resolved_mixins[mixin.resource_path]['instantiate'] = false

	# check if identifiers are unique
	var identifiers : Array = []
	var signals     : Array = \
		PressAccept_Typer_ObjectInfo.script_signal_info(type).keys()
	var properties  : Array = \
		PressAccept_Typer_ObjectInfo.script_property_info(type).keys()
	var methods     : Array = \
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
				return 'Error: Duplicate Method Identifiers - "' + method + '"'

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
	var args: String = ''
	for arg in range(init_args.size()):
		args += 'arg' + str(arg) + ', '
	args = args.trim_suffix(', ')
	source_code += args + ').(' + args + ") -> void:\n"

	for mixin in resolved_mixins:
		mixin = resolved_mixins[mixin]
		source_code += \
			mixin['info'].generate_init(mixin['instantiate'], is_tool)

	# generate wrapper methods
	for mixin in resolved_mixins:
		mixin = resolved_mixins[mixin]['info']
		source_code += mixin.generate_methods()

	# instantiate our wrapper oobject
	var generated_script = GDScript.new()
	generated_script.source_code = source_code
	generated_script.reload()
	return generated_script


static func instantiate(
		type,                     # String | Script
		init_args : Array,
		is_tool   : bool = true): # -> String | Object

	var generated_script = generate_script(type, init_args, is_tool)

	if generated_script is Script:
		return generated_script.callv('new', init_args)

	return null

