extends Node3D

@onready var audio_stream_player = $AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	audio_stream_player.play()


var is_going = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_going:
		global_position += Vector3(0, 10 * delta, 0)


func _on_up_timer_timeout():
	is_going = true


func _on_delete_timer_timeout():
	queue_free()
