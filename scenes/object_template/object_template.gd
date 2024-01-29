extends StaticBody2D

@export var conversation : Conversation

signal send_dialogue(array_of_dialogues)

func is_interactable() -> bool:
	if(conversation == null):
		return false;
	else:
		return true;

func get_conversation() -> Conversation:
	return conversation;
