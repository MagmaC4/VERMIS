extends Node3D

@export var player : CharacterBody3D
@export var other_screen : Node3D
@onready var camera : Camera3D = $SubViewport/Camera3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# translate the camera 
	var offset = player.global_position - global_position
	camera.global_position = other_screen.global_position + offset
	
	# rotate the camera
