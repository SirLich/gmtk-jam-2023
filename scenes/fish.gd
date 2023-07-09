extends CharacterBody3D

@export var speed = 80
@export var boost_speed = 200
@export var turn_speed = 0.02
@export var vert_speed = 60
@export var max_tilt = 0.2
@onready var color_rect = $ColorRect
@export var HUNGER_LOSS = 0.5
@export var HUNGER_PLUS = 20

@onready var hunger : ProgressBar = $Hunger

var is_playing_minigame = false
var current_rot = 0
var rot_ammount = 300

@onready var anim_player : AnimationPlayer = find_child("AnimationPlayer", true, false)
@onready var chomp_sound = $ChompSound
@onready var texture_progress_bar = $TextureProgressBar

@onready var track_dot = $TextureProgressBar/TrackDot

var current_food

var hunger_level = 90.0

func _ready():
	hunger.value = hunger_level

func start_playing():
	color_rect.visible = true
	texture_progress_bar.visible = true
	current_rot = randi_range(0, 360)
	is_playing_minigame = true
	chomp_sound.play()
	
func stop_playing():
	color_rect.visible = false
	texture_progress_bar.visible = false
	is_playing_minigame = false
	if current_food:
		current_food.queue_free()
	
	print(fmod(track_dot.rotation_degrees, 360))
	print(texture_progress_bar.value)
	
	if fmod(track_dot.rotation_degrees, 360) > texture_progress_bar.value:
		print("You lose")
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	else:
		texture_progress_bar.value = texture_progress_bar.value * 0.9
		hunger_level += HUNGER_PLUS
		hunger_level = max(hunger_level, 100)
		chomp_sound.play()
		
func play_game(delta):
	track_dot.rotation_degrees = current_rot
	current_rot += fmod((rot_ammount * delta), 360)
	
	if Input.is_action_just_released("eat"):
		stop_playing()
	
func _process(delta):
	hunger_level = hunger_level - (HUNGER_LOSS * delta)
	
	hunger.value = hunger_level
	if hunger_level <= 0.1:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
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


func _on_area_3d_area_entered(area : Area3D):
	current_food = area.get_parent()
	start_playing()


func _on_timer_timeout():
	HUNGER_LOSS += 0.5
