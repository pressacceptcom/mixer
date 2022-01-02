tool


static func __mixable_info() -> PressAccept_Mixer_Mixin:

	return PressAccept_Mixer_Mixin.new(
		'mixable5',
		'res://addons/PressAccept/Mixer/test/unit/Mixable5.gd',
		[ 'mixed_method5' ],
		[ 'mixed_property5' ],
		[ 'mixed_signal5' ]
	)


signal mixed_signal5(arg1, emitter)

var mixed_property5: String = ''
var nonmixed_property5: String = ''

var _self: Object

func _init(
		init_self: Object) -> void:

	_self = init_self


func mixed_method5(an_argument: String) -> void:
	emit_signal('mixed_signal5', 5, _self);


func another_mixed_method5() -> void:
	pass


func nonmixed_method5() -> void:
	nonmixed_property5 = ''

