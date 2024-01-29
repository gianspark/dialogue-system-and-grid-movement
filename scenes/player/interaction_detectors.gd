extends Node2D

@onready var raycast_wall = $raycast_wall
@onready var raycast_interaction = $raycast_interaction

func wall_detection() -> bool:
	return raycast_wall.is_colliding();

func interact_detection() -> bool:
	return raycast_interaction.is_colliding();

func get_interactable() -> Object:
	return raycast_interaction.get_collider();
