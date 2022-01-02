extends 'res://addons/gut/test.gd'

# |---------|
# | Imports |
# |---------|

# see test/Utilities.gd
var TestUtilities : Script = PressAccept_Mixer_Test_Utilities
# shorthand for our library class
var Mixin         : Script = PressAccept_Mixer_Mixin

# |-------|
# | Tests |
# |-------|


func test_combine() -> void:

	var mixin: PressAccept_Mixer_Mixin = Mixin.combine(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd',
		[
			'res://addons/PressAccept/Mixer/test/unit/Mixable3.gd',
			'res://addons/PressAccept/Mixer/test/unit/Mixable4.gd'
		]
	)

	var methods3: Dictionary = PressAccept_Typer_ObjectInfo.script_method_info(
		'res://addons/PressAccept/Mixer/test/unit/Mixable3.gd'
	)

	var methods4: Dictionary = PressAccept_Typer_ObjectInfo.script_method_info(
		'res://addons/PressAccept/Mixer/test/unit/Mixable4.gd'
	)

	methods3['mixed_method3']['mixin'] = true
	methods4['mixed_method4']['mixin'] = true
	methods4['another_mixed_method4']['mixin'] = true

	var properties3: Dictionary = \
		PressAccept_Typer_ObjectInfo.script_property_info(
			'res://addons/PressAccept/Mixer/test/unit/Mixable3.gd'
		)

	var properties4: Dictionary = \
		PressAccept_Typer_ObjectInfo.script_property_info(
			'res://addons/PressAccept/Mixer/test/unit/Mixable4.gd'
		)

	var signals3: Dictionary = PressAccept_Typer_ObjectInfo.script_signal_info(
		'res://addons/PressAccept/Mixer/test/unit/Mixable3.gd'
	)

	var signals4: Dictionary = PressAccept_Typer_ObjectInfo.script_signal_info(
		'res://addons/PressAccept/Mixer/test/unit/Mixable4.gd'
	)

	assert_eq(mixin.identifier, 'mixable1')

	assert_eq(
		mixin._mixin_script,
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
	)

	assert_eq_deep(
		mixin._methods,
		{
			'mixed_method3': methods3['mixed_method3'],
			'mixed_method4': methods4['mixed_method4'],
			'another_mixed_method4': methods4['another_mixed_method4']
		}
	)

	assert_eq_deep(
		mixin._properties,
		{
			'mixed_property3': properties3['mixed_property3'],
			'mixed_property4': properties4['mixed_property4'],
			'another_mixed_property4': properties4['another_mixed_property4']
		}
	)

	assert_eq_deep(
		mixin._signals,
		{
			'mixed_signal3': signals3['mixed_signal3'],
			'mixed_signal4': signals4['mixed_signal4'],
			'another_mixed_signal4': signals4['another_mixed_signal4']
		}
	)

	assert_eq(
		mixin.requires,
		[ 'res://addons/PressAccept/Mixer/test/unit/Mixable5.gd' ]
	)


func test__init() -> void:

	var mixin: PressAccept_Mixer_Mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
	)

	assert_eq(mixin.identifier, 'mixable1')
	assert_eq(mixin.requires, [])

	assert_eq(
		mixin._mixin_script,
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
	)
	assert_eq_shallow(mixin._methods, {})
	assert_eq_shallow(mixin._properties, {})
	assert_eq_shallow(mixin._signals, {})

	mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd',
		[ 'mixed_method1' ],
		[ 'mixed_property1' ],
		[ 'mixed_signal1' ],
		[ 'res://addons/PressAccept/Mixer/test/unit/Mixable2.gd' ]
	)

	assert_eq(mixin.identifier, 'mixable1')
	assert_eq(
		mixin.requires,
		[ 'res://addons/PressAccept/Mixer/test/unit/Mixable2.gd' ]
	)

	assert_eq(
		mixin._mixin_script,
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
	)

	var methods: Dictionary = PressAccept_Typer_ObjectInfo.script_method_info(
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
	)

	var properties: Dictionary = \
		PressAccept_Typer_ObjectInfo.script_property_info(
			'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
		)

	var signals: Dictionary = PressAccept_Typer_ObjectInfo.script_signal_info(
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
	)

	assert_eq_deep(
		mixin._methods,
		{ 'mixed_method1': methods['mixed_method1'] }
	)

	assert_eq_deep(
		mixin._properties,
		{ 'mixed_property1': properties['mixed_property1'] }
	)

	assert_eq_deep(
		mixin._signals,
		{ 'mixed_signal1': signals['mixed_signal1'] }
	)


func test_add_dependency() -> void:

	var mixin: PressAccept_Mixer_Mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
	)

	mixin.add_dependency('res://addons/PressAccept/Mixer/test/unit/Mixable1.gd')

	assert_eq(
		mixin.requires,
		[ 'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd' ]
	)

	mixin.add_dependency('res://addons/PressAccept/Mixer/test/unit/Mixable1.gd')

	assert_eq(
		mixin.requires,
		[ 'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd' ]
	)

	mixin.add_dependency('res://addons/PressAccept/Mixer/test/unit/Mixed.gd')

	assert_eq(
		mixin.requires,
		[
			'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd',
			'res://addons/PressAccept/Mixer/test/unit/Mixed.gd'
		]
	)

	# chaining

	mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
	)

	mixin \
		.add_dependency('res://addons/PressAccept/Mixer/test/unit/Mixable1.gd') \
		.add_dependency('res://addons/PressAccept/Mixer/test/unit/Mixed.gd')

	assert_eq(
		mixin.requires,
		[
			'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd',
			'res://addons/PressAccept/Mixer/test/unit/Mixed.gd'
		]
	)


func test_add_dependencies() -> void:

	var mixin: PressAccept_Mixer_Mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
	)

	mixin.add_dependencies([
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd',
		'res://addons/PressAccept/Mixer/test/unit/Mixed.gd',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
	])

	assert_eq(
		mixin.requires,
		[
			'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd',
			'res://addons/PressAccept/Mixer/test/unit/Mixed.gd'
		]
	)

	# chaining

	mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
	)

	mixin \
		.add_dependencies([
			'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
		]) \
		.add_dependencies([
			'res://addons/PressAccept/Mixer/test/unit/Mixed.gd',
			'res://addons/PressAccept/Mixer/test/unit/Mixable2.gd'
		])

	assert_eq(
		mixin.requires,
		[
			'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd',
			'res://addons/PressAccept/Mixer/test/unit/Mixed.gd',
			'res://addons/PressAccept/Mixer/test/unit/Mixable2.gd'
		]
	)


func test_remove_dependency() -> void:

	var mixin: PressAccept_Mixer_Mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd',
		[],
		[],
		[],
		[
			'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd',
			'res://addons/PressAccept/Mixer/test/unit/Mixed.gd'
		]
	)

	assert_eq(
		mixin.requires,
		[
			'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd',
			'res://addons/PressAccept/Mixer/test/unit/Mixed.gd'
		]
	)

	mixin.remove_dependency('res://addons/PressAccept/Mixer/test/unit/Mixed.gd')

	assert_eq(
		mixin.requires,
		[ 'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd' ]
	)

	mixin.remove_dependency(
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
	)

	assert_eq(mixin.requires, [])

	# chaining

	mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd',
		[],
		[],
		[],
		[
			'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd',
			'res://addons/PressAccept/Mixer/test/unit/Mixed.gd',
			'res://addons/PressAccept/Mixer/test/unit/Mixable2.gd'
		]
	)

	mixin \
		.remove_dependency('res://addons/PressAccept/Mixer/test/unit/Mixed.gd') \
		.remove_dependency('res://addons/PressAccept/Mixer/test/unit/Mixable2.gd')

	assert_eq(
		mixin.requires,
		[ 'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd' ]
	)


func test_add_method() -> void:

	var mixin: PressAccept_Mixer_Mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
	)

	assert_eq_shallow(mixin._methods, {})

	var methods: Dictionary = PressAccept_Typer_ObjectInfo.script_method_info(
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
	)

	mixin.add_method('mixed_method1')

	assert_eq_deep(
		mixin._methods,
		{ 'mixed_method1': methods['mixed_method1'] }
	)

	mixin.add_method('mixed_method2')

	assert_eq_deep(
		mixin._methods,
		{ 'mixed_method1': methods['mixed_method1'] }
	)

	var other_methods: Dictionary = \
		PressAccept_Typer_ObjectInfo.script_method_info(
			'res://addons/PressAccept/Mixer/test/unit/Mixable2.gd'
		)

	other_methods['mixed_method2']['mixin'] = true

	mixin.add_method(
		'mixed_method2',
		'res://addons/PressAccept/Mixer/test/unit/Mixable2.gd'
	)

	assert_eq_deep(
		mixin._methods,
		{
			'mixed_method1': methods['mixed_method1'],
			'mixed_method2': other_methods['mixed_method2']
		}
	)

	# chaining

	mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
	)

	mixin\
		.add_method('mixed_method1') \
		.add_method(
			'mixed_method2',
			'res://addons/PressAccept/Mixer/test/unit/Mixable2.gd'
		)

	assert_eq_deep(
		mixin._methods,
		{
			'mixed_method1': methods['mixed_method1'],
			'mixed_method2': other_methods['mixed_method2']
		}
	)


func test_add_methods() -> void:

	var mixin: PressAccept_Mixer_Mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
	)

	assert_eq_shallow(mixin._methods, {})

	var methods: Dictionary = PressAccept_Typer_ObjectInfo.script_method_info(
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
	)

	mixin.add_methods([
		'mixed_method1',
		'nonmixed_method1'
	])

	assert_eq_deep(
		mixin._methods,
		{
			'mixed_method1': methods['mixed_method1'],
			'nonmixed_method1': methods['nonmixed_method1']
		}
	)

	mixin.add_methods(
		[ 'mixed_method2' ],
		'res://addons/PressAccept/Mixer/test/unit/Mixable2.gd'
	)

	var other_methods: Dictionary = \
		PressAccept_Typer_ObjectInfo.script_method_info(
			'res://addons/PressAccept/Mixer/test/unit/Mixable2.gd'
		)

	other_methods['mixed_method2']['mixin'] = true

	assert_eq_deep(
		mixin._methods,
		{
			'mixed_method1': methods['mixed_method1'],
			'nonmixed_method1': methods['nonmixed_method1'],
			'mixed_method2': other_methods['mixed_method2']
		}
	)

	# chaining

	mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
	)

	mixin \
		.add_methods([ 'mixed_method1', 'nonmixed_method1' ]) \
		.add_methods(
			[ 'mixed_method2' ],
			'res://addons/PressAccept/Mixer/test/unit/Mixable2.gd'
		)

	assert_eq_deep(
		mixin._methods,
		{
			'mixed_method1': methods['mixed_method1'],
			'nonmixed_method1': methods['nonmixed_method1'],
			'mixed_method2': other_methods['mixed_method2']
		}
	)


func test_remove_method() -> void:

	var mixin: PressAccept_Mixer_Mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd',
		[ 'mixed_method1' ]
	)

	var methods: Dictionary = PressAccept_Typer_ObjectInfo.script_method_info(
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
	)

	assert_eq_deep(
		mixin._methods,
		{
			'mixed_method1': methods['mixed_method1']
		}
	)

	var return_value: bool = mixin.remove_method('mixed_method1')

	assert_eq_shallow(mixin._methods, {})
	assert_true(return_value)

	return_value = mixin.remove_method('mixed_method2')

	assert_false(return_value)


func test_get_method() -> void:

	var mixin: PressAccept_Mixer_Mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd',
		[ 'mixed_method1' ]
	)

	var methods: Dictionary = PressAccept_Typer_ObjectInfo.script_method_info(
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
	)

	assert_eq_deep(mixin.get_method('mixed_method1'), methods['mixed_method1'])

	assert_eq(mixin.get_method('mixed_method2'), null)


func test_get_method_identifiers():

	var mixin: PressAccept_Mixer_Mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd',
		[ 'mixed_method1', 'nonmixed_method1' ]
	)

	assert_eq(
		mixin.get_method_identifiers(),
		[ 'mixed_method1', 'nonmixed_method1' ]
	)

	mixin.remove_method('nonmixed_method1')

	assert_eq(mixin.get_method_identifiers(), [ 'mixed_method1' ])


func test_add_property() -> void:

	var mixin: PressAccept_Mixer_Mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
	)

	assert_eq_shallow(mixin._properties, {})

	var properties: Dictionary = \
		PressAccept_Typer_ObjectInfo.script_property_info(
			'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
		)

	mixin.add_property('mixed_property1')

	assert_eq_deep(
		mixin._properties,
		{ 'mixed_property1': properties['mixed_property1'] }
	)

	mixin.add_property('mixed_property2')

	assert_eq_deep(
		mixin._properties,
		{ 'mixed_property1': properties['mixed_property1'] }
	)

	var other_properties: Dictionary = \
		PressAccept_Typer_ObjectInfo.script_property_info(
			'res://addons/PressAccept/Mixer/test/unit/Mixable2.gd'
		)

	mixin.add_property(
		'mixed_property2',
		'res://addons/PressAccept/Mixer/test/unit/Mixable2.gd'
	)

	assert_eq_deep(
		mixin._properties,
		{
			'mixed_property1': properties['mixed_property1'],
			'mixed_property2': other_properties['mixed_property2']
		}
	)

	# chaining

	mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
	)

	mixin\
		.add_property('mixed_property1') \
		.add_property(
			'mixed_property2',
			'res://addons/PressAccept/Mixer/test/unit/Mixable2.gd'
		)

	assert_eq_deep(
		mixin._properties,
		{
			'mixed_property1': properties['mixed_property1'],
			'mixed_property2': other_properties['mixed_property2']
		}
	)


func test_add_properties() -> void:

	var mixin: PressAccept_Mixer_Mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
	)

	assert_eq_shallow(mixin._properties, {})

	var properties: Dictionary = \
		PressAccept_Typer_ObjectInfo.script_property_info(
			'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
		)

	mixin.add_properties([
		'mixed_property1',
		'nonmixed_property1'
	])

	assert_eq_deep(
		mixin._properties,
		{
			'mixed_property1': properties['mixed_property1'],
			'nonmixed_property1': properties['nonmixed_property1']
		}
	)

	mixin.add_properties(
		[ 'mixed_property2' ],
		'res://addons/PressAccept/Mixer/test/unit/Mixable2.gd'
	)

	var other_properties: Dictionary = \
		PressAccept_Typer_ObjectInfo.script_property_info(
			'res://addons/PressAccept/Mixer/test/unit/Mixable2.gd'
		)

	assert_eq_deep(
		mixin._properties,
		{
			'mixed_property1': properties['mixed_property1'],
			'nonmixed_property1': properties['nonmixed_property1'],
			'mixed_property2': other_properties['mixed_property2']
		}
	)

	# chaining

	mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
	)

	mixin \
		.add_properties([ 'mixed_property1', 'nonmixed_property1' ]) \
		.add_properties(
			[ 'mixed_property2' ],
			'res://addons/PressAccept/Mixer/test/unit/Mixable2.gd'
		)

	assert_eq_deep(
		mixin._properties,
		{
			'mixed_property1': properties['mixed_property1'],
			'nonmixed_property1': properties['nonmixed_property1'],
			'mixed_property2': other_properties['mixed_property2']
		}
	)


func test_remove_property() -> void:

	var mixin: PressAccept_Mixer_Mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd',
		[],
		[ 'mixed_property1' ]
	)

	var properties: Dictionary = \
		PressAccept_Typer_ObjectInfo.script_property_info(
			'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
		)

	assert_eq_deep(
		mixin._properties,
		{
			'mixed_property1': properties['mixed_property1']
		}
	)

	var return_value: bool = mixin.remove_property('mixed_property1')

	assert_eq_shallow(mixin._properties, {})
	assert_true(return_value)

	return_value = mixin.remove_property('mixed_property2')

	assert_false(return_value)


func test_get_property() -> void:

	var mixin: PressAccept_Mixer_Mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd',
		[],
		[ 'mixed_property1' ]
	)

	var properties: Dictionary = \
		PressAccept_Typer_ObjectInfo.script_property_info(
			'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
		)

	assert_eq_deep(
		mixin.get_property('mixed_property1'),
		properties['mixed_property1']
	)

	assert_eq(mixin.get_property('mixed_property2'), null)


func test_get_property_identifiers():

	var mixin: PressAccept_Mixer_Mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd',
		[],
		[ 'mixed_property1', 'nonmixed_property1' ]
	)

	assert_eq(
		mixin.get_property_identifiers(),
		[ 'mixed_property1', 'nonmixed_property1' ]
	)

	mixin.remove_property('nonmixed_property1')

	assert_eq(mixin.get_property_identifiers(), [ 'mixed_property1' ])


func test_add_signal() -> void:

	var mixin: PressAccept_Mixer_Mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
	)

	assert_eq_shallow(mixin._signals, {})

	var signals: Dictionary = \
		PressAccept_Typer_ObjectInfo.script_signal_info(
			'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
		)

	mixin.add_signal('mixed_signal1')

	assert_eq_deep(
		mixin._signals,
		{ 'mixed_signal1': signals['mixed_signal1'] }
	)

	mixin.add_signal('mixed_signal2')

	assert_eq_deep(
		mixin._signals,
		{ 'mixed_signal1': signals['mixed_signal1'] }
	)

	var other_signals: Dictionary = \
		PressAccept_Typer_ObjectInfo.script_signal_info(
			'res://addons/PressAccept/Mixer/test/unit/Mixable2.gd'
		)

	mixin.add_signal(
		'mixed_signal2',
		'res://addons/PressAccept/Mixer/test/unit/Mixable2.gd'
	)

	assert_eq_deep(
		mixin._signals,
		{
			'mixed_signal1': signals['mixed_signal1'],
			'mixed_signal2': other_signals['mixed_signal2']
		}
	)

	# chaining

	mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
	)

	mixin\
		.add_signal('mixed_signal1') \
		.add_signal(
			'mixed_signal2',
			'res://addons/PressAccept/Mixer/test/unit/Mixable2.gd'
		)

	assert_eq_deep(
		mixin._signals,
		{
			'mixed_signal1': signals['mixed_signal1'],
			'mixed_signal2': other_signals['mixed_signal2']
		}
	)


func test_add_signals() -> void:

	var mixin: PressAccept_Mixer_Mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
	)

	assert_eq_shallow(mixin._signals, {})

	var signals: Dictionary = \
		PressAccept_Typer_ObjectInfo.script_signal_info(
			'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
		)

	mixin.add_signals([
		'mixed_signal1',
		'nonmixed_signal1'
	])

	assert_eq_deep(
		mixin._signals,
		{
			'mixed_signal1': signals['mixed_signal1'],
			'nonmixed_signal1': signals['nonmixed_signal1']
		}
	)

	mixin.add_signals(
		[ 'mixed_signal2' ],
		'res://addons/PressAccept/Mixer/test/unit/Mixable2.gd'
	)

	var other_signals: Dictionary = \
		PressAccept_Typer_ObjectInfo.script_signal_info(
			'res://addons/PressAccept/Mixer/test/unit/Mixable2.gd'
		)

	assert_eq_deep(
		mixin._signals,
		{
			'mixed_signal1': signals['mixed_signal1'],
			'nonmixed_signal1': signals['nonmixed_signal1'],
			'mixed_signal2': other_signals['mixed_signal2']
		}
	)

	# chaining

	mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
	)

	mixin \
		.add_signals([ 'mixed_signal1', 'nonmixed_signal1' ]) \
		.add_signals(
			[ 'mixed_signal2' ],
			'res://addons/PressAccept/Mixer/test/unit/Mixable2.gd'
		)

	assert_eq_deep(
		mixin._signals,
		{
			'mixed_signal1': signals['mixed_signal1'],
			'nonmixed_signal1': signals['nonmixed_signal1'],
			'mixed_signal2': other_signals['mixed_signal2']
		}
	)


func test_remove_signal() -> void:

	var mixin: PressAccept_Mixer_Mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd',
		[],
		[],
		[ 'mixed_signal1' ]
	)

	var signals: Dictionary = \
		PressAccept_Typer_ObjectInfo.script_signal_info(
			'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
		)

	assert_eq_deep(
		mixin._signals,
		{
			'mixed_signal1': signals['mixed_signal1']
		}
	)

	var return_value: bool = mixin.remove_signal('mixed_signal1')

	assert_eq_shallow(mixin._signals, {})
	assert_true(return_value)

	return_value = mixin.remove_signal('mixed_signal2')

	assert_false(return_value)


func test_get_signal() -> void:

	var mixin: PressAccept_Mixer_Mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd',
		[],
		[],
		[ 'mixed_signal1' ]
	)

	var signals: Dictionary = \
		PressAccept_Typer_ObjectInfo.script_signal_info(
			'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
		)

	assert_eq_deep(mixin.get_signal('mixed_signal1'), signals['mixed_signal1'])

	assert_eq(mixin.get_signal('mixed_signal2'), null)


func test_get_signal_identifiers():

	var mixin: PressAccept_Mixer_Mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd',
		[],
		[],
		[ 'mixed_signal1', 'nonmixed_signal1' ]
	)

	assert_eq(
		mixin.get_signal_identifiers(),
		[ 'mixed_signal1', 'nonmixed_signal1' ]
	)

	mixin.remove_signal('nonmixed_signal1')

	assert_eq(mixin.get_signal_identifiers(), [ 'mixed_signal1' ])


func test_generate_signals() -> void:

	var mixin: PressAccept_Mixer_Mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd',
		[],
		[],
		[ 'mixed_signal1', 'nonmixed_signal1' ]
	)

	var source_code: String = mixin.generate_signals()

	assert_eq(
		source_code,
		"""
signal mixed_signal1()
signal nonmixed_signal1(argument, emitter)
"""
	)


func test_generate_properties() -> void:

	var mixin: PressAccept_Mixer_Mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd',
		[],
		[ 'mixed_property1', 'nonmixed_property1']
	)

	var source_code: String = mixin.generate_properties()

	assert_eq(
		source_code,
		"""
var mixable1
var mixed_property1 setget _set_mixed_property1, _get_mixed_property1
var nonmixed_property1 setget _set_nonmixed_property1, _get_nonmixed_property1
"""
	)


func test_generate_init() -> void:

	var mixin: PressAccept_Mixer_Mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
	)

	var source_code: String = mixin.generate_init()

	assert_eq(
		source_code,
		"""
	mixable1 = load('res://addons/PressAccept/Mixer/test/unit/Mixable1.gd').new(self)

"""
	)

	mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd',
		[],
		[],
		[ 'mixed_signal1', 'nonmixed_signal1' ]
	)

	source_code = mixin.generate_init()

	assert_eq(
		source_code,
		"""
	mixable1 = load('res://addons/PressAccept/Mixer/test/unit/Mixable1.gd').new(self)

	mixable1.connect("mixed_signal1", self, "_on_mixed_signal1")
	mixable1.connect("nonmixed_signal1", self, "_on_nonmixed_signal1")
"""
	)

	source_code = mixin.generate_init(true, false)

	assert_eq(
		source_code,
		"""
	mixable1 = PressAccept_Mixer_Mixer.instantiate('res://addons/PressAccept/Mixer/test/unit/Mixable1.gd', [self], false)

	mixable1.connect("mixed_signal1", self, "_on_mixed_signal1")
	mixable1.connect("nonmixed_signal1", self, "_on_nonmixed_signal1")
"""
	)

	source_code = mixin.generate_init(true, true, 'arg0')

	assert_eq(
		source_code,
		"""
	mixable1 = PressAccept_Mixer_Mixer.instantiate('res://addons/PressAccept/Mixer/test/unit/Mixable1.gd', [arg0], true)

	mixable1.connect("mixed_signal1", self, "_on_mixed_signal1")
	mixable1.connect("nonmixed_signal1", self, "_on_nonmixed_signal1")
"""
	)


func test_generate_methods() -> void:

	var mixin: PressAccept_Mixer_Mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd',
		[],
		[],
		[]
	)

	var source_code: String = mixin.generate_methods()

	assert_eq(source_code, '')

	mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd',
		[ 'mixed_method1' ],
		[ 'mixed_property1' ],
		[ 'mixed_signal1' ]
	)

	source_code = mixin.generate_methods()

	assert_eq(
		source_code,
		"""
func _on_mixed_signal1():
	emit_signal("mixed_signal1")

func _set_mixed_property1(
		new_mixed_property1):
	mixable1.mixed_property1 = new_mixed_property1

func _get_mixed_property1():
	if mixable1:
		return mixable1.mixed_property1
	return null

func mixed_method1(
		arg0 = PressAccept_Mixer_Mixin.DefaultArgument):
	var args: Array = PressAccept_Mixer_Mixin._trim_defaults([arg0])
	return mixable1.callv("mixed_method1", args)
"""
	)

	mixin = Mixin.new(
		'mixable1',
		'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd',
		[ 'mixed_method1', 'nonmixed_method1' ],
		[ 'mixed_property1', 'nonmixed_property1' ],
		[ 'mixed_signal1', 'nonmixed_signal1' ]
	)

	source_code = mixin.generate_methods()

	assert_eq(
		source_code,
		"""
func _on_mixed_signal1():
	emit_signal("mixed_signal1")

func _on_nonmixed_signal1(
		argument,
		emitter):
	emit_signal("nonmixed_signal1", argument, emitter)

func _set_mixed_property1(
		new_mixed_property1):
	mixable1.mixed_property1 = new_mixed_property1

func _get_mixed_property1():
	if mixable1:
		return mixable1.mixed_property1
	return null

func _set_nonmixed_property1(
		new_nonmixed_property1):
	mixable1.nonmixed_property1 = new_nonmixed_property1

func _get_nonmixed_property1():
	if mixable1:
		return mixable1.nonmixed_property1
	return null

func mixed_method1(
		arg0 = PressAccept_Mixer_Mixin.DefaultArgument):
	var args: Array = PressAccept_Mixer_Mixin._trim_defaults([arg0])
	return mixable1.callv("mixed_method1", args)

func nonmixed_method1(
		arg0 = PressAccept_Mixer_Mixin.DefaultArgument,
		arg1 = PressAccept_Mixer_Mixin.DefaultArgument):
	var args: Array = PressAccept_Mixer_Mixin._trim_defaults([arg0, arg1])
	return mixable1.callv("nonmixed_method1", args)
"""
	)

