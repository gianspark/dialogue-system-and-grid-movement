extends Control

@onready var option_box = preload("res://scenes/textbox/option_box.tscn")

@onready var author : Label = $ColorRect/VBoxContainer/author
@onready var textlabel : Label = $ColorRect/VBoxContainer/text
@onready var typed_speed : Timer = $typedSpeed
var conversation : Conversation
var dialogue : Dialogue
var showed_phrase : String = ""
var complete_phrase : String = ""
var letter : int = 0

signal end_text

var options : bool = false
var options_array : Array[Option]
var option_selection : int = 0
const min_option_select : int = 0
var max_option_select : int
var option_nodes : Array

var message_finished : bool = true
var in_chat : bool = false
var actual_number_message : int = 0
var dialog_index : int = 0

func _process(_delta) -> void:
	if(in_chat):
		if(options):
			if(Input.is_action_just_pressed("arriba")):
				select_option(-1)
			elif(Input.is_action_just_pressed("abajo")):
				select_option(+1)
		if(Input.is_action_just_pressed("interaccion")):
			if(message_finished == false):
				speed_up_text()
			elif(options):
				delete_options()
				next_message()
			else:
				next_message()

func reset() -> void:
	in_chat = false
	message_finished = true
	actual_number_message = 0
	dialog_index = 0
	conversation = null
	dialogue = null
	clear_option_boxes()
	clear_text()

func clear_text() -> void:
	author.text = ""
	textlabel.text = ""
	complete_phrase = ""
	letter = 0
	showed_phrase = ""

func clear_option_boxes():
	options = false
	option_selection = 0
	options_array = []
	option_nodes = []
	max_option_select = 0

func get_conversation(conv : Conversation) -> void:
	reset()
	conversation = conv
	dialogue = conversation.dialogo[dialog_index]
	next_message()
	var timer = Timer.new()
	timer.wait_time = 0.1
	add_child(timer)
	timer.start()
	show()
	await timer.timeout
	in_chat = true
	timer.queue_free()

func new_dialogue(parameter : int) -> void:
	dialog_index = conversation.find_by_id(parameter)
	dialogue = conversation.dialogo[dialog_index]
	actual_number_message = 0

func next_message() -> void:
	if(dialogue.messages.size() <= actual_number_message):
		if(dialogue.valid_end()):
			finish();
			return;
		else:
			new_dialogue(dialogue.id_to_next)
	clear_text()
	complete_phrase = dialogue.messages[actual_number_message].message
	author.text = dialogue.messages[actual_number_message].author
	typed_speed.wait_time = 1 / dialogue.messages[actual_number_message].text_speed
	actual_number_message+=1
	typed_speed.start()
	message_finished = false

func finish() -> void:
	in_chat = false
	hide()
	emit_signal("end_text")

func speed_up_text() -> void:
	showed_phrase = complete_phrase
	textlabel.text = showed_phrase

func _on_typed_speed_timeout() -> void:
	if(showed_phrase.length() != complete_phrase.length()):
		showed_phrase += complete_phrase.substr(letter,1)
		textlabel.text = showed_phrase
		letter+=1;
	else:
		message_finished = true
		typed_speed.stop()
		if(!dialogue.check_options(actual_number_message-1)):
			option_box_creator()

func option_box_creator():
	options_array = dialogue.messages[actual_number_message-1].options
	for i in options_array.size():
		var option = options_array[i]
		var new_option_box = option_box.instantiate()
		$qsy/VBoxContainer.add_child(new_option_box)
		option_nodes.append(new_option_box)
		new_option_box.set_text(option.option)
	max_option_select = options_array.size()-1
	options = true
	select_option(0)

func select_option(n : int):
	option_nodes[option_selection].hide_border();
	option_selection = clamp(option_selection+n,min_option_select,max_option_select)
	option_nodes[option_selection].show_border();

func delete_options():
	options = false
	var numb = options_array[option_selection].option_number
	new_dialogue(numb)
	for i in option_nodes:
		i.queue_free()
	clear_option_boxes()
