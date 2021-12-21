extends Node2D

signal a_signal(arg1, arg2)

var a_property: String


func another_method():
	pass


func a_method(arg1: String = 'blah', arg2: int = 5):
	if arg2 == 5:
		arg1 = str(arg2)
		
	return another_method()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mixed_object = PressAccept_Mixer_Mixer.instantiate(
		'res://addons/PressAccept/Mixer/test/unit/Mixed.gd',
		[ 'init' ]
	)
	
	mixed_object.mixed_method1()
	mixed_object.mixed_property2 = 'accessing directly'
	
	mixed_object.connect('mixed_signal2', self, '_on_mixed_signal2')
	mixed_object.mixed_method2('mixed method 2')


func _on_mixed_signal2(arg1, emitter) -> void:
	print('Signal fired!' + str(arg1) + str(emitter))

