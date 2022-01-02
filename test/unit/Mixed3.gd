tool

static func __mixed_info() -> Array:
	return [
		'res://addons/PressAccept/Mixer/test/unit/Mixable3.gd'
	]


var my_own_property: String = ''


func _init(init_my_own_property: String) -> void:
	my_own_property = init_my_own_property


func my_own_method() -> void:
	print('My own method:' + my_own_property)

