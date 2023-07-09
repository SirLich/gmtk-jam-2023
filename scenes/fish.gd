extends CharacterBody3D

@export var speed = 80
@export var boost_speed = 200
@export var turn_speed = 0.02
@export var vert_speed = 60
@export var max_tilt = 0.2

var is_playing_minigame = false
var current_rot = 0
var rot_ammount = 300

@onready var anim_player : AnimationPlayer = find_child("AnimationPlayer", true, false)

@onready var track_dot = $TextureProgressBar/TrackDot

func _ready():
	pass # Replace with function body.

func start_playing():
	current_rot = randi_range(0, 360)
	is_playing_minigame = true
	
func play_game(delta):
	track_dot.rotation_degrees = current_rot
	current_rot += fmod((rot_ammount * delta), 360)
	
func _process(delta):
	if is_playing_minigame:
		play_game(delta)
		return
	
	if Input.is_action_just_released("test_game"):
		start_playing()
		
	var use_speed = speed
	if Input.is_action_pressed("right"):
		global_rotate(Vector3.UP, -turn_speed)
	if Input.is_action_pressed("left"):
		global_rotate(Vector3.UP, turn_speed)
	if Input.is_action_pressed("boost"):
		anim_player.speed_scale = 1.2
		use_speed = boost_speed;
	else:
		anim_player.speed_scale = 0.2
	if Input.is_action_pressed("slow"):
		use_speed = 30
	
	var facing = global_transform.basis.x
	velocity = facing * use_speed * delta;
	
	if Input.is_action_pressed("up"):
		velocity += (Vector3.UP * vert_speed * delta)
#		global_rotate(Vector3.FORWARD, tilt_speed)
	if Input.is_action_pressed("down"):
		velocity += (Vector3.UP * -vert_speed * delta)
		
	move_and_slide()
