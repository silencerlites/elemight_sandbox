extends Node3D

@export var Enemy: PackedScene
@onready var spawn_timer = $spawn_timer

var enemies_remaining_to_spawn 
var enemies_killed_this_wave
# list of all the wave nodes: [wave 1, wave 2, wave 3, ...]
var waves 
var current_wave: Wave
var current_wave_level = -1

func _ready():
	waves = $Waves.get_children()
	print("Waves", waves)
	_start_next_wave()

func _start_next_wave():
	enemies_killed_this_wave = 0
	current_wave_level += 1
	if current_wave_level < waves.size():
		current_wave = waves[current_wave_level]
		enemies_remaining_to_spawn = current_wave.num_enemies
		spawn_timer.wait_time = current_wave.second_between_spawn
		spawn_timer.start()
	
func connect_to_enemy_signals(enemy: Enemy):
	var stats: Stats = enemy.get_node("Stats")
	stats.connect("_enemy_die_signal", _on_stats__enemy_die_signal)

func _on_stats__enemy_die_signal():
	enemies_killed_this_wave += 1
	print("Enemies killed: ", enemies_killed_this_wave)
	
func _on_spawn_timer_timeout():
	if enemies_remaining_to_spawn:
		#Spawn
		var enemy = Enemy.instantiate()
		connect_to_enemy_signals(enemy)
		var scene_root = get_parent()
		scene_root.add_child(enemy)
		enemies_remaining_to_spawn -= 1
	else:
		if enemies_killed_this_wave == current_wave.num_enemies:
			_start_next_wave()
