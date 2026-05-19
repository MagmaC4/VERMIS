extends MeshInstance3D

@export var linked_portal : Node3D
var can_teleport := true

# local portal = portal being entered
# linked portal = portal being exited 
func _on_area_3d_body_entered(body: Node3D) -> void:
	print(name + " body entered")
	
	# can_teleport prevents teleporting back and forth endlessly
	if (body.is_in_group("Player") and can_teleport and linked_portal.can_teleport):
		# POSITION TRANSFORM
		body.global_position = linked_portal.global_position
		
		# VELOCITY TRANSFORM
		var local_vel = global_transform.basis.inverse() * body.velocity
		var linked_vel = linked_portal.global_transform.basis * local_vel
		body.velocity = linked_vel

		
		# CLEANUP
		can_teleport = false
		linked_portal.can_teleport = false
		

func _on_area_3d_body_exited(body: Node3D) -> void:
	print(name + " body exited")
	if body.is_in_group("Player"):
		can_teleport = true
