extends CharacterBody3D

@export var speed = 100
@export var boost_speed = 300
@export var turn_speed = 0.02
@export var vert_speed = 200
@export var max_tilt = 0.2


@onready var anim_player : AnimationPlayer = find_child("AnimationPlayer", true, false)

func _ready():
	pass # Replace with function body.

func _process(delta):
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
	
	var facing = global_transform.basis.x
	velocity = facing * use_speed * delta;
	
	if Input.is_action_pressed("up"):
		velocity += (Vector3.UP * vert_speed * delta)
#		global_rotate(Vector3.FORWARD, tilt_speed)
	if Input.is_action_pressed("down"):
		velocity += (Vector3.UP * -vert_speed * delta)
		
	
		

	move_and_slide()
