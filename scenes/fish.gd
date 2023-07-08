extends CharacterBody3D

@export var speed = 100;
@export var boost_speed = 300;
@export var turn_speed = 0.02

func _ready():
	pass # Replace with function body.

func _process(delta):
	var use_speed = speed
	if Input.is_action_pressed("right"):
		global_rotate(Vector3.UP, -turn_speed)
	if Input.is_action_pressed("left"):
		global_rotate(Vector3.UP, turn_speed)
	if Input.is_action_pressed("boost"):
		use_speed = boost_speed;
	
	var facing = global_transform.basis.x
	velocity = facing * use_speed * delta;
	move_and_slide()
