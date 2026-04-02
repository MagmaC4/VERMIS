extends Camera3D

@export var camera_sensitivity_controller := 100
@export var camera_sensitivity_mouse := 5
var mouse_input : Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	# Lock mouse to window on ready
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	
func _physics_process(delta: float) -> void:
	# Camera rotates only when mouse is focused
	if (Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		handle_camera_v2(delta)
		
# Override _input function to keep track of MouseMotion
# event is a variable that records all InputEvents
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_input = event.relative
	elif event.is_action_pressed("ui_cancel"):
		# Unlock mouse to window
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event.is_action_pressed("attack"):
		# Lock mouse to window
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# handle camera rotation with input map (Controller)
func handle_camera_v1(delta):
	# var look_input = Input.get_vector("move_backward", "move_forward", "move_right", "move_left")
	var look_input = Input.get_vector("look_right", "look_left", "look_down", "look_up")
	look_input = look_input * camera_sensitivity_controller * delta
	rotation_degrees.x += look_input.x 
	rotation_degrees.x = clampf(rotation_degrees.x, -90, 90)
	rotation_degrees.y += look_input.y
	
# handle camera rotation with input event (Mouse)
func handle_camera_v2(delta):
	var look_input = (-1) * mouse_input
	look_input = look_input  * camera_sensitivity_mouse * delta
	# Rotate camera based on look_input vector
	rotation_degrees.x += look_input.y
	rotation_degrees.x = clampf(rotation_degrees.x, -90, 90)
	rotation_degrees.y += look_input.x
	# Reset mouse_input (necessary or else your mouse will feel like it's sliding)
	mouse_input = Vector2.ZERO
