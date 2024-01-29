extends Node

@onready var interaction_detectors = $"../interaction_detectors"
signal in_chat(objeto)
@onready var player = $".."

func _process(_delta) -> void:
	if(Input.is_action_just_pressed("interaccion") and player.in_chat == false):
		if(interaction_detectors.interact_detection()):
			var objeto = interaction_detectors.get_interactable();
			if(objeto.is_interactable()):
				emit_signal("in_chat",objeto)
