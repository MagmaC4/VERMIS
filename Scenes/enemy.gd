extends Node3D

@export var max_health := 30
@onready var health := max_health


func take_damage(amount : int):
	health -= amount
	if (health <= 0):
		health = 0
		on_death()

func heal(amount : int):
	health += amount
	if (health > max_health):
		health = max_health
		
func on_death():
	var explosion_anim_1 = $AnimatedSprite3D
	var explosion_sfx = $AudioStreamPlayer3D
	
	print("Enemy Died")
	$MeshInstance3D.hide()
	$Hitbox.set_deferred("monitoring", false)
	explosion_anim_1.play()
	explosion_sfx.play()
	get_tree().create_timer(1.0).timeout.connect(queue_free)

	
	
	
func _on_hitbox_area_entered(area: Area3D) -> void:
	if (area.is_in_group("Weapon")):
		take_damage(5)
		print("Health: " + str(health))
