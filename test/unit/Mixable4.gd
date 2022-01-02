tool


static func __mixable_info() -> PressAccept_Mixer_Mixin:

	return PressAccept_Mixer_Mixin.new(
		'mixable4',
		'res://addons/PressAccept/Mixer/test/unit/Mixable4.gd',
		[ 'mixed_method4', 'another_mixed_method4' ],
		[ 'mixed_property4', 'another_mixed_property4' ],
		[ 'mixed_signal4', 'another_mixed_signal4' ],
		[ 'res://addons/PressAccept/Mixer/test/unit/Mixable5.gd' ]
	)


signal mixed_signal4(arg1, emitter)
signal another_mixed_signal4()

var mixed_property4: String = ''
var another_mixed_property4: String = ''
var nonmixed_property4: String = ''

var _self: Object

func _init(
		init_self: Object) -> void:

	_self = init_self


func mixed_method4(an_argument: String) -> void:
	emit_signal('mixed_signal4', 5, _self);


func another_mixed_method4() -> void:
	pass


func nonmixed_method4() -> void:
	nonmixed_property4 = ''

