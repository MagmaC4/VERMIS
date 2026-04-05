extends Node3D

@export var max_health := 100
@onready var health := max_health


func take_damage(amount : int):
	health -= amount
	if (health < 0):
		health = 0

func heal(amount : int):
	health += amount
	if (health > max_health):
		health = max_health
	
	
func _on_hitbox_area_entered(area: Area3D) -> void:
	if (area.is_in_group("Weapon")):
		take_damage(5)
		print("Health: " + str(health))
