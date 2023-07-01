extends Node3D

@export var bullet: PackedScene
@onready var rof_timer = $Timer

@export var muzzle_speed = 30
@export var millies_between_shot = 100

var can_shoot = true

func _ready():
	rof_timer.wait_time = millies_between_shot / 1000.0

func _shoot(delta):
	if can_shoot:
		var new_bullet = bullet.instantiate()
		new_bullet.global_transform = $Muzzle.global_transform
		new_bullet.bullet_shoot_speed = muzzle_speed
		var scene_root = get_tree().get_root().get_children()[0]
		scene_root.add_child(new_bullet)
#		print("Pew!")
		can_shoot = false
		rof_timer.start()

func _on_timer_timeout():
	print("You can shoot again")
	can_shoot = true
