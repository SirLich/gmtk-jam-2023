extends Node3D

@export var hooked_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_random_pos():
	var positions = $Positions
	return positions.get_children().pick_random().global_transform
	
func _on_timer_timeout():
	var new_hook : Node3D = hooked_scene.instantiate()
	new_hook.global_transform = get_random_pos()
	add_child(new_hook)
