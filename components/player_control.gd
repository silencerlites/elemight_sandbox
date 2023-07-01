extends CharacterBody3D

@onready var gun_control = $"Gun Controller"

const rotation_speed = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y -= gravity * delta
	_movement(delta)
	_shoot(delta)

func _movement(delta) -> void:
	if Input.is_action_pressed("left"):
		if rotation.y <= 1.56:
			rotate_y(delta * rotation_speed)

	if Input.is_action_pressed("right"):
		if rotation.y >= -1.56:
			rotate_y(-rotation_speed * delta)

func _shoot(delta) -> void:
	if Input.is_action_pressed("shoot"):
		gun_control._shoot(delta)
