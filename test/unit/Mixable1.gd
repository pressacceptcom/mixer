tool

static func __mixed_info() -> Array:
	return [ 'res://addons/PressAccept/Mixer/test/unit/Mixable2.gd' ]

static func __mixable_info() -> PressAccept_Mixer_Mixin:

	var mixin_info: PressAccept_Mixer_Mixin = \
		PressAccept_Mixer_Mixin.new(
			'mixable1',
			'res://addons/PressAccept/Mixer/test/unit/Mixable1.gd'
		)

	mixin_info.add_signal('mixed_signal1') \
		.add_property('mixed_property1') \
		.add_method('mixed_method1')

	var mixin2: String = 'res://addons/PressAccept/Mixer/test/unit/Mixable2.gd'

	mixin_info.add_signal('mixed_signal2', mixin2) \
		.add_property('mixed_property2', mixin2) \
		.add_method('mixed_method2', mixin2)

	return mixin_info


signal mixed_signal1()


var mixed_property1: String = ''
var nonmixed_property1: String = ''

var _self: Object

func _init(
		init_self: Object) -> void:

	_self = init_self


func mixed_method1(an_argument: String = 'default argument') -> void:
	nonmixed_property1 = an_argument


func nonmixed_method1() -> void:
	nonmixed_property1 = ''

