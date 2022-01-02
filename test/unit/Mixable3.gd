tool


static func __mixable_info() -> PressAccept_Mixer_Mixin:

	return PressAccept_Mixer_Mixin.new(
		'mixable3',
		'res://addons/PressAccept/Mixer/test/unit/Mixable3.gd',
		[ 'mixed_method3' ],
		[ 'mixed_property3' ],
		[ 'mixed_signal3' ]
	)


signal mixed_signal3(arg1, emitter)


var mixed_property3: String = ''
var nonmixed_property3: String = ''

var _self: Object

func _init(
		init_self: Object) -> void:

	_self = init_self


func mixed_method3(an_argument: String) -> void:
	emit_signal('mixed_signal3', 5, _self);


func nonmixed_method3() -> void:
	nonmixed_property3 = ''

