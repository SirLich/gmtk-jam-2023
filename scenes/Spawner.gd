extends Node3D

@export var hooked_scene : PackedScene

var positions
var current = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	positions = $Positions.get_children()
	positions.shuffle()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_random_pos():
	current += 1
	current = current % len(positions)
	
	return positions[current].global_transform
	
func _on_timer_timeout():
	var new_hook : Node3D = hooked_scene.instantiate()
	new_hook.global_transform = get_random_pos()
	add_child(new_hook)
