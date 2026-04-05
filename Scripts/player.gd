extends CharacterBody3D

# Movement
var SPEED = 5.0
var JUMP_VELOCITY = 4.5
var dev_mode_enabled : bool = false
var DEV_MODE_SPEED := 25.0
var is_sliding : bool
var slide_accel = 5000

# Auxillary
@onready var camera : Camera3D = $Camera3D
@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var weapon_hitbox : Area3D = $Camera3D/WeaponPivot/Sword/Hitbox

func _physics_process(delta: float) -> void:
	# Player movement
	if (dev_mode_enabled):
		handle_movement_dev_mode(delta)
	else:
		handle_movement(delta)
	
	handle_slide(delta)

func _process(delta):
	toggle_dev_mode()
	
	# Player Attack
	handle_weapon(delta)

# ATTACK ======================================================================
func handle_weapon(delta : float) -> void:
	if Input.is_action_just_pressed("attack"):
		anim_player.play("weapon_attack")
		weapon_hitbox.monitorable = true
		
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "weapon_attack":
		anim_player.play("weapon_idle")
		weapon_hitbox.monitorable = false


# MOVEMENT ====================================================================
func handle_slide(delta):
	var floor_normal : Vector3 = get_floor_normal()
	var gravity : Vector3 = Vector3.DOWN
	var slope_dir : Vector3 = (gravity - floor_normal * gravity.dot(floor_normal)).normalized()
	var slope_angle = rad_to_deg(acos(floor_normal.dot(Vector3.UP)))
	
	# ONLY APPLY SLIDE WHEN PLAYER IS ON GROUND AND ON STEEP SLOPE
	if Input.is_action_pressed("slide") and is_on_floor() and slope_angle > 10: 
		is_sliding = true
		var diff = slope_dir * slide_accel * delta
		diff.z *= 2 # double gravity 
		velocity += diff # apply slope slide to player velocity
		
		if (Input.is_action_just_pressed("slide")):
			anim_player.play("cam_slide_start")
		
	elif Input.is_action_just_released("slide"):
		anim_player.play("cam_slide_end")
		
	else:
		is_sliding = false

		
	


func handle_movement_dev_mode(delta):
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := camera.global_basis * Vector3(input_dir.x, 0, input_dir.y).normalized()
	position += direction * delta * DEV_MODE_SPEED
	
func handle_movement(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	# set direction of movement relative to camera
	var direction := camera.global_basis * Vector3(input_dir.x, 0, input_dir.y)
	direction.y = 0 # remove y component of camera direction
	direction = direction.normalized() # normalize direction
	
	# Handle sprint multiplier
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
	
# MISCELLANEOUS ===============================================================
func toggle_dev_mode():
	if Input.is_action_just_pressed("toggle_dev_mode"):
		dev_mode_enabled = !dev_mode_enabled
