extends CharacterBody3D


var SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var camera : Camera3D = $Camera3D
@onready var anim_player : AnimationPlayer = $AnimationPlayer


func _physics_process(delta: float) -> void:		
	# Player movement
	handle_movement(delta)
	handle_weapon(delta)
	
func handle_weapon(delta : float) -> void:
	if Input.is_action_just_pressed("attack"):
		anim_player.play("weapon_attack")
		
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "weapon_attack":
		anim_player.play("weapon_idle")
	
func handle_movement(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	# set direction of movement relative to camera
	var direction := camera.global_basis * Vector3(input_dir.x, 0, input_dir.y)
	direction.y = 0 # remove y component of camera direction
	direction = direction.normalized() # normalize direction
	
	var sprint_speed = 1
	if (Input.is_action_pressed("sprint")):
		sprint_speed = 1.5
	
	if direction:
		velocity.x = direction.x * SPEED * sprint_speed
		velocity.z = direction.z * SPEED * sprint_speed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		

	move_and_slide()
