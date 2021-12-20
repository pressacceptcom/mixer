tool

static func __mixable_info() -> PressAccept_Mixer_Mixin:

	var mixin_info: PressAccept_Mixer_Mixin = \
		PressAccept_Mixer_Mixin.new(
			'mixable2',
			'res://addons/PressAccept/Mixer/test/unit/Mixable2.gd'
		)

	mixin_info.add_signal('mixed_signal2') \
		.add_property('mixed_property2') \
		.add_method('mixed_method2')

	return mixin_info


signal mixed_signal2(arg1)


var mixed_property2: String = ''
var nonmixed_property2: String = ''


func mixed_method2(_self, an_argument: String) -> void:
	emit_signal('mixed_signal2', 5);


func nonmixed_method2() -> void:
	nonmixed_property2 = ''

