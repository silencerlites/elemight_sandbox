extends Node

class_name Stats

@export var max_HP = 10
var current_HP = max_HP

signal _enemy_die_signal

func _take_hit(damage):
#	Current Hp is the damage that take not the bullet damage
	current_HP -= damage
	print("I'm hit! ", current_HP, "/", max_HP)
	
	if current_HP <= 0:
		_die()

func _die():
	emit_signal("_enemy_die_signal")
	#queue_free()
