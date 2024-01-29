extends Node2D

@onready var textbox = $CanvasLayer/textbox
@onready var tile_map = $TileMap
@onready var player = $Player

signal end_chat()

func _on_player_send_dialogues(conversation) -> void:
	textbox.get_conversation(conversation);

func _process(_delta) -> void:
	check_tile()

func check_tile():
	if(Input.is_action_just_pressed("menu")):
		print(tile_map.get_tile());

func _on_textbox_end_text() -> void:
	emit_signal("end_chat")
