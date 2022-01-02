extends 'res://addons/gut/test.gd'

# |---------|
# | Imports |
# |---------|

# see test/Utilities.gd
var TestUtilities : Script = PressAccept_Mixer_Test_Utilities
# shorthand for our library class
var Mixer         : Script = PressAccept_Mixer_Mixer

# |-------|
# | Tests |
# |-------|

var signaled: bool = false

func test_is_mixable() -> void:

	assert_true(
		Mixer.is_mixable('res://addons/PressAccept/Mixer/test/unit/Mixable3.gd')
	)

	assert_true(
		Mixer.is_mixable('res://addons/PressAccept/Mixer/test/unit/Mixable1.gd')
	)

	assert_false(
		Mixer.is_mixable('res://addons/PressAccept/Mixer/test/unit/Mixed1.gd')
	)


func test_is_mixed() -> void:

	assert_true(
		Mixer.is_mixed('res://addons/PressAccept/Mixer/test/unit/Mixed1.gd')
	)

	assert_true(
		Mixer.is_mixable('res://addons/PressAccept/Mixer/test/unit/Mixable1.gd')
	)

	assert_false(
		Mixer.is_mixed('res://addons/PressAccept/Mixer/test/unit/Mixable3.gd')
	)


func test_generate_script() -> void:

	var generated_script: Script = Mixer.generate_script(
		'res://addons/PressAccept/Mixer/test/unit/Mixed3.gd'
	)

	assert_true(generated_script.can_instance())
	assert_true(generated_script.is_tool())
	assert_eq(
		generated_script.source_code,
		"""tool
extends 'res://addons/PressAccept/Mixer/test/unit/Mixed3.gd'

signal mixed_signal3(arg1, emitter)

var mixable3
var mixed_property3 setget _set_mixed_property3, _get_mixed_property3

func _init(arg0).(arg0) -> void:

	mixable3 = load('res://addons/PressAccept/Mixer/test/unit/Mixable3.gd').new(self)

	mixable3.connect("mixed_signal3", self, "_on_mixed_signal3")

func _on_mixed_signal3(
		arg1,
		emitter):
	emit_signal("mixed_signal3", arg1, emitter)

func _set_mixed_property3(
		new_mixed_property3):
	mixable3.mixed_property3 = new_mixed_property3

func _get_mixed_property3():
	if mixable3:
		return mixable3.mixed_property3
	return null

func mixed_method3(
		arg0 = PressAccept_Mixer_Mixin.DefaultArgument):
	var args: Array = PressAccept_Mixer_Mixin._trim_defaults([arg0])
	return mixable3.callv("mixed_method3", args)
"""
	)

	generated_script = Mixer.generate_script(
		'res://addons/PressAccept/Mixer/test/unit/Mixed1.gd',
		false
	)

	assert_true(generated_script.can_instance())
	assert_false(generated_script.is_tool())
	assert_eq(
		generated_script.source_code,
		"""extends 'res://addons/PressAccept/Mixer/test/unit/Mixed1.gd'

signal mixed_signal1()
signal mixed_signal2(arg1, emitter)

var mixable1
var mixed_property1 setget _set_mixed_property1, _get_mixed_property1
var mixed_property2 setget _set_mixed_property2, _get_mixed_property2

func _init(arg0).(arg0) -> void:

	mixable1 = PressAccept_Mixer_Mixer.instantiate('res://addons/PressAccept/Mixer/test/unit/Mixable1.gd', [self], false)

	mixable1.connect("mixed_signal1", self, "_on_mixed_signal1")
	mixable1.connect("mixed_signal2", self, "_on_mixed_signal2")

func _on_mixed_signal1():
	emit_signal("mixed_signal1")

func _on_mixed_signal2(
		arg1,
		emitter):
	emit_signal("mixed_signal2", arg1, emitter)

func _set_mixed_property1(
		new_mixed_property1):
	mixable1.mixed_property1 = new_mixed_property1

func _get_mixed_property1():
	if mixable1:
		return mixable1.mixed_property1
	return null

func _set_mixed_property2(
		new_mixed_property2):
	mixable1.mixed_property2 = new_mixed_property2

func _get_mixed_property2():
	if mixable1:
		return mixable1.mixed_property2
	return null

func mixed_method1(
		arg0 = PressAccept_Mixer_Mixin.DefaultArgument):
	var args: Array = PressAccept_Mixer_Mixin._trim_defaults([arg0])
	return mixable1.callv("mixed_method1", args)

func mixed_method2(
		arg0 = PressAccept_Mixer_Mixin.DefaultArgument):
	var args: Array = PressAccept_Mixer_Mixin._trim_defaults([arg0])
	return mixable1.callv("mixed_method2", args)
"""
	)

	generated_script = Mixer.generate_script(
		'res://addons/PressAccept/Mixer/test/unit/Mixed4.gd',
		false
	)

	assert_true(generated_script.can_instance())
	assert_false(generated_script.is_tool())
	assert_eq(
		generated_script.source_code,
		"""extends 'res://addons/PressAccept/Mixer/test/unit/Mixed4.gd'

signal mixed_signal4(arg1, emitter)
signal another_mixed_signal4()

signal mixed_signal5(arg1, emitter)

var mixable4
var mixed_property4 setget _set_mixed_property4, _get_mixed_property4
var another_mixed_property4 setget _set_another_mixed_property4, _get_another_mixed_property4

var mixable5
var mixed_property5 setget _set_mixed_property5, _get_mixed_property5

func _init(arg0 = PressAccept_Mixer_Mixin.DefaultArgument).() -> void:

	mixable4 = load('res://addons/PressAccept/Mixer/test/unit/Mixable4.gd').new(self)

	mixable4.connect("mixed_signal4", self, "_on_mixed_signal4")
	mixable4.connect("another_mixed_signal4", self, "_on_another_mixed_signal4")

	mixable5 = load('res://addons/PressAccept/Mixer/test/unit/Mixable5.gd').new(self)

	mixable5.connect("mixed_signal5", self, "_on_mixed_signal5")

	if has_method('__init'):
		var args: Array = PressAccept_Mixer_Mixin._trim_defaults([arg0])

		self.callv('__init', args)

func _on_mixed_signal4(
		arg1,
		emitter):
	emit_signal("mixed_signal4", arg1, emitter)

func _on_another_mixed_signal4():
	emit_signal("another_mixed_signal4")

func _set_mixed_property4(
		new_mixed_property4):
	mixable4.mixed_property4 = new_mixed_property4

func _get_mixed_property4():
	if mixable4:
		return mixable4.mixed_property4
	return null

func _set_another_mixed_property4(
		new_another_mixed_property4):
	mixable4.another_mixed_property4 = new_another_mixed_property4

func _get_another_mixed_property4():
	if mixable4:
		return mixable4.another_mixed_property4
	return null

func mixed_method4(
		arg0 = PressAccept_Mixer_Mixin.DefaultArgument):
	var args: Array = PressAccept_Mixer_Mixin._trim_defaults([arg0])
	return mixable4.callv("mixed_method4", args)

func another_mixed_method4():
	var args: Array = PressAccept_Mixer_Mixin._trim_defaults([])
	return mixable4.callv("another_mixed_method4", args)

func _on_mixed_signal5(
		arg1,
		emitter):
	emit_signal("mixed_signal5", arg1, emitter)

func _set_mixed_property5(
		new_mixed_property5):
	mixable5.mixed_property5 = new_mixed_property5

func _get_mixed_property5():
	if mixable5:
		return mixable5.mixed_property5
	return null

func mixed_method5(
		arg0 = PressAccept_Mixer_Mixin.DefaultArgument):
	var args: Array = PressAccept_Mixer_Mixin._trim_defaults([arg0])
	return mixable5.callv("mixed_method5", args)
"""
	)


func _catch_signal(
		argument1,
		argument2):

	signaled = true


func test_instantiate() -> void:

	var ObjectInfo: Script = PressAccept_Typer_ObjectInfo

	var instantiation = Mixer.instantiate(
		'res://addons/PressAccept/Mixer/test/unit/Mixed3.gd',
		[ 'set_own_property' ]
	)

	assert_true(instantiation.get_script().is_tool())

	var tests: Dictionary = {
		[ 'mixed_method3' ]:
			{ TestUtilities.ASSERTION : TestUtilities.TRUE },
		[ 'nonmixed_method3' ]:
			{ TestUtilities.ASSERTION : TestUtilities.FALSE },
	}

	TestUtilities.batch(self, tests, funcref(instantiation, 'has_method'))

	assert_true(instantiation.has_signal('mixed_signal3'))

	tests = {
		[ instantiation, 'my_own_property' ]:
			{ TestUtilities.ASSERTION : TestUtilities.TRUE },
		[ instantiation, 'mixed_property3' ]:
			{ TestUtilities.ASSERTION : TestUtilities.TRUE },
		[ instantiation, 'nonmixed_property3' ]:
			{ TestUtilities.ASSERTION : TestUtilities.FALSE },
	}

	TestUtilities.batch(self, tests, funcref(ObjectInfo, 'object_has_property'))

	assert_eq(instantiation.my_own_property, 'set_own_property')

	instantiation.connect('mixed_signal3', self, '_catch_signal')

	signaled = false
	instantiation.mixed_method3('an_argument_value')

	assert_true(signaled)

	instantiation = Mixer.instantiate(
		'res://addons/PressAccept/Mixer/test/unit/Mixed1.gd',
		[ 'set_own_property' ],
		false
	)

	assert_false(instantiation.get_script().is_tool())

	tests = {
		[ 'mixed_method1' ]:
			{ TestUtilities.ASSERTION : TestUtilities.TRUE },
		[ 'mixed_method2' ]:
			{ TestUtilities.ASSERTION : TestUtilities.TRUE },
		[ 'nonmixed_method1' ]:
			{ TestUtilities.ASSERTION : TestUtilities.FALSE },
		[ 'nonmixed_method2' ]:
			{ TestUtilities.ASSERTION : TestUtilities.FALSE }
	}

	TestUtilities.batch(self, tests, funcref(instantiation, 'has_method'))

	tests = {
		[ 'mixed_signal1' ]:
			{ TestUtilities.ASSERTION : TestUtilities.TRUE },
		[ 'mixed_signal2' ]:
			{ TestUtilities.ASSERTION : TestUtilities.TRUE },
		[ 'nonmixed_signal1' ]:
			{ TestUtilities.ASSERTION : TestUtilities.FALSE }
	}

	TestUtilities.batch(self, tests, funcref(instantiation, 'has_signal'))

	tests = {
		[ instantiation, 'mixed_property1' ]:
			{ TestUtilities.ASSERTION : TestUtilities.TRUE },
		[ instantiation, 'mixed_property2' ]:
			{ TestUtilities.ASSERTION : TestUtilities.TRUE },
		[ instantiation, 'nonmixed_property1' ]:
			{ TestUtilities.ASSERTION : TestUtilities.FALSE },
		[ instantiation, 'nonmixed_property2' ]:
			{ TestUtilities.ASSERTION : TestUtilities.FALSE }
	}

	TestUtilities.batch(self, tests, funcref(ObjectInfo, 'object_has_property'))

	assert_eq(instantiation.my_own_property, 'set_own_property')

	instantiation.mixed_method1('nonmixed_value')
	assert_eq(instantiation.mixable1.nonmixed_property1, 'nonmixed_value')

	instantiation.connect('mixed_signal2', self, '_catch_signal')

	signaled = false
	instantiation.mixed_method2('an_argument_value')

	assert_true(signaled)

	instantiation = Mixer.instantiate(
		'res://addons/PressAccept/Mixer/test/unit/Mixed4.gd',
		[ 'set_own_property' ]
	)

	assert_true(instantiation.get_script().is_tool())

	tests = {
		[ 'mixed_method4' ]:
			{ TestUtilities.ASSERTION : TestUtilities.TRUE },
		[ 'another_mixed_method4' ]:
			{ TestUtilities.ASSERTION : TestUtilities.TRUE },
		[ 'mixed_method5' ]:
			{ TestUtilities.ASSERTION : TestUtilities.TRUE },
		[ 'nonmixed_method4' ]:
			{ TestUtilities.ASSERTION : TestUtilities.FALSE },
		[ 'nonmixed_method5' ]:
			{ TestUtilities.ASSERTION : TestUtilities.FALSE }
	}

	TestUtilities.batch(self, tests, funcref(instantiation, 'has_method'))

	tests = {
		[ 'mixed_signal4' ]:
			{ TestUtilities.ASSERTION : TestUtilities.TRUE },
		[ 'another_mixed_signal4' ]:
			{ TestUtilities.ASSERTION : TestUtilities.TRUE },
		[ 'mixed_signal5' ]:
			{ TestUtilities.ASSERTION : TestUtilities.TRUE }
	}

	TestUtilities.batch(self, tests, funcref(instantiation, 'has_signal'))

	tests = {
		[ instantiation, 'mixed_property4' ]:
			{ TestUtilities.ASSERTION : TestUtilities.TRUE },
		[ instantiation, 'another_mixed_property4' ]:
			{ TestUtilities.ASSERTION : TestUtilities.TRUE },
		[ instantiation, 'mixed_property5' ]:
			{ TestUtilities.ASSERTION : TestUtilities.TRUE },
		[ instantiation, 'nonmixed_property4' ]:
			{ TestUtilities.ASSERTION : TestUtilities.FALSE },
		[ instantiation, 'nonmixed_property5' ]:
			{ TestUtilities.ASSERTION : TestUtilities.FALSE }
	}

	TestUtilities.batch(self, tests, funcref(ObjectInfo, 'object_has_property'))

	instantiation.connect('mixed_signal4', self, '_catch_signal')
	instantiation.connect('mixed_signal5', self, '_catch_signal')

	signaled = false
	instantiation.mixed_method4('an_argument_value')

	assert_true(signaled)

	signaled = false
	instantiation.mixed_method5('an_argument_value')

	assert_true(signaled)

