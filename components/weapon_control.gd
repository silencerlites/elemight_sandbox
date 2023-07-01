extends Node

@export var starting_weapon: PackedScene
var hand: Marker3D
var equiped_weapon : Node

func _ready():
	hand = get_parent().find_child("Hand")
	if starting_weapon:
		_equip_weapon(starting_weapon)

func _equip_weapon(weapon_to_equip):
	if equiped_weapon:
		print("Delete current weapon")
		equiped_weapon.queue_free()
	else:
		print("No Weapon Equiped")
		equiped_weapon = weapon_to_equip.instantiate()
		hand.add_child(equiped_weapon)

func _shoot(delta):
	if equiped_weapon:
		equiped_weapon._shoot(delta)
