extends Resource

class_name Message

@export_category("Main Category")
@export_multiline var message : String
@export var author : String = ""
@export_category("Extra Category")
@export var text_speed : float = 100.0;
@export var options : Array[Option];
@export var execute_at_begin : Script
@export var execute_at_end : Script

func check_options() -> bool:
	return options.is_empty()
