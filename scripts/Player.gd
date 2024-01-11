extends CharacterBody3D



const JUMP_VELOCITY = 4.5

var speed = 5.0
var walking_speed = 3.0
var running_speed =5.0
var running = false

@export var sens_horizontal = 0.5
@export var sens_vertical = 0.1
@onready var camera_mount = $Camera_Mount
@onready var animation_player = $Visual/mixamo_base/AnimationPlayer
@onready var visual = $Visual


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*sens_horizontal))
		visual.rotate_y(deg_to_rad(event.relative.x*sens_horizontal))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y*sens_vertical))


func _physics_process(delta):
	
	# Shift to run
	if Input.is_action_pressed("run"):
		speed = running_speed
		running = true
	else:
		speed = walking_speed
		running = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "foward", "backward")
	# var input_dir = Input.get_vector(KEY_A, KEY_D, KEY_W, KEY_S)
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if running:
			if animation_player.current_animation != "running":
				animation_player.play("running")

		else:
			if animation_player.current_animation != "walking":
				animation_player.play("walking")


		
		visual.look_at(position + direction)

		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		if animation_player.current_animation != "idle":
			animation_player.play("idle")
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
