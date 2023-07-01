extends CharacterBody3D
class_name Enemy

enum states{
	patrol,
	chasing,
	hunting,
	waiting
}

@onready var anim_player = $"test_slime/AnimationPlayer"
@onready var player_path = $"../Player"
@onready  var nav_agent = $NavigationAgent3D
@onready var way_point : Array = [$"../Patrol Path/Marker3D", $"../Patrol Path/Marker3D2", $"../Patrol Path/Marker3D3"]
@onready var patrol_timer = $patrol_timer

var current_state : states
var speed = 3.0
var player = null
var way_point_index : int

# Area Setup
var player_in_earshot_far : bool
var player_in_earshot_close : bool
var player_in_sight_far: bool
var player_in_sight_close: bool

func _ready():
	current_state = states.patrol
	nav_agent.set_target_position(way_point[0].global_position)
	player = player_path


func _process(delta):
	match current_state:
		states.patrol:
			anim_player.play("walk")
			if(nav_agent.is_navigation_finished()):
				current_state = states.waiting
				patrol_timer.start()
				return
			move_towards_point(delta, speed)

#		states.chasing:
#			anim_player.play("walk")
#			if(nav_agent.is_navigation_finished()):
#				patrol_timer.start()
#				current_state = states.waiting
#			nav_agent.set_target_position(player.global_transform.origin)
#			move_towards_point(delta, speed)
#			pass
#
#		states.hunting:
#			anim_player.play("walk")
#			if(nav_agent.is_navigation_finished()):
#				patrol_timer.start()
#				current_state = states.waiting
#			move_towards_point(delta, speed)
#			pass

		states.waiting:
			anim_player.play("idle")
			pass
	pass

#
## Check if the player is enter the area 
#func check_for_player():
#	var space_state = get_world_3d().direct_space_state
#	var result = space_state.intersect_ray(PhysicsRayQueryParameters3D.create($Head.global_position, player_path.global_position, 1, [self]))
#	if result.size() > 0:
#		if(result["collider"].player_path):
#			if(player_in_earshot_close):
#				current_state = states.chasing
#
#			if(player_in_earshot_far):
#				current_state = states.hunting
#				nav_agent.set_target_position(player.global_transform.origin)
#
#			if(player_in_sight_close):
#				current_state = states.chasing
#
#			if(player_in_sight_far):
#				current_state = states.hunting
#				nav_agent.set_target_position(player.global_transform.origin)

# Movement of Enemy to the point or object
func move_towards_point(delta, speed):
	var target_position = nav_agent.get_next_path_position()
	var direction = global_position.direction_to(target_position)
	face_direction(target_position)
	velocity = direction * speed
	move_and_slide()
#	if(player_in_earshot_far):
#		check_for_player()


# Function of facing to the point or object  
func face_direction(direction: Vector3):
	look_at(Vector3(direction.x, global_position.y, direction.z), Vector3.UP)


# Signal for Chasing when enter the specific area allocated
func _on_patrol_timer_timeout():
	current_state = states.patrol
	way_point_index += 1
	if way_point_index > way_point.size() - 1:
		way_point_index = 0
	nav_agent.set_target_position(way_point[way_point_index].global_position)


func _on_hearing_far_body_entered(body):
	if body.player_path:
		player_in_earshot_far = true
		print("Player is entered far earshot")
	pass # Replace with function body.

func _on_hearing_far_body_exited(body):
	if body.player_path:
		player_in_earshot_far = false
		print("Player has left far earshot")
	pass # Replace with function body.

func _on_hearing_closing_body_entered(body):
	if body.player_path:
		player_in_earshot_close = true
		print("Player is close in earshot")
	pass # Replace with function body.

func _on_hearing_closing_body_exited(body):
	if body.player_path:
		player_in_earshot_close = false
		print("Player has left in earshot")
	pass # Replace with function body.

func _on_sight_far_body_entered(body):
	if body.player_path:
		player_in_sight_far = true
		print("Player has entered far sight")
	pass # Replace with function body.

func _on_sight_far_body_exited(body):
	if body.player_path:
		player_in_sight_far = false
		print("Player has left far sight")
	pass # Replace with function body.

func _on_sight_close_body_entered(body):
	if body.player_path:
		player_in_sight_close = true
		print("Player has entered close sight")
	pass # Replace with function body.

func _on_sight_close_body_exited(body):
	if body.player_path:
		player_in_sight_close = false
		print("Player has left close sight")
	pass # Replace with function body.

# Function when the enemy is die
func _on_stats__enemy_die_signal():
	queue_free()



# CHASING PLAYER
#	velocity = Vector3.ZERO
#	#Nvigation
#	nav_agent.set_target_position(player.global_transform.origin)
#	var next_nav_point = nav_agent.get_next_path_position()
#	velocity = (next_nav_point - global_transform.origin).normalized() * speed
#	look_at(Vector3(player.global_position.x, player.global_position.y, player.global_position.z), Vector3.UP)
#	move_and_slide()
