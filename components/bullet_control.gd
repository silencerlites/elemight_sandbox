extends Node3D

@export var bullet_shoot_speed = 70
@export var bullet_damage = 5

const destroy_bullet_time = 2
var timer = 0

func _physics_process(delta):
	var forward_direction = global_transform.basis.z.normalized()
	global_translate(forward_direction * bullet_shoot_speed * delta)
	
	timer += delta
	if timer >= destroy_bullet_time:
		print("Destroy Bullet")
		queue_free()

func _on_area_3d_body_entered(body: Node):
	print("I hit you ", body)
	queue_free()
	
	if body.has_node("Stats"):
		var stat_node = body.get_node("Stats") as Stats
		stat_node._take_hit(bullet_damage)
