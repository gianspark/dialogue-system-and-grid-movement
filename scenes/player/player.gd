extends CharacterBody2D

signal send_dialogues(conversation : Conversation)

var in_chat : bool = false

@export var desplazamiento_max : int = 32;
@export var velocidad : float;
@export var velocidad_walking : float = 3.0;
@export var velocidad_sprint : float = 4.3;

enum mirando{DER,IZQ,ARR,ABA};
var looking : mirando
enum estado{IDLE,WALKING,TURNING};
var state : estado

#variables para el movimiento por celda
var desplazamiento_actual : float = 0;
var en_movimiento : bool = false;
var direction : Vector2 = Vector2.ZERO;
var movimiento_origen : Vector2 = Vector2.ZERO
var movimiento_final : Vector2 = Vector2.ZERO

@onready var interaction_detectors = $interaction_detectors
@onready var turn_timer = $TurnTimer

func _ready() -> void:
	velocidad = velocidad_walking;
	state = estado.IDLE;
	looking = mirando.DER;

func _process(delta) -> void:
	if(!in_chat):
		Sprint();
		Movimiento(delta);

func Movimiento(delta) -> void:
	if(state == estado.IDLE or state == estado.WALKING):
		if(!en_movimiento):
			if(Input.is_action_pressed("izquierda")):
				if(looking == mirando.IZQ):
					Direction(Vector2(-1,0),global_position + Vector2(-desplazamiento_max,0))
				else:
					Turning(mirando.IZQ,180);
			elif(Input.is_action_pressed("derecha")):
				if(looking == mirando.DER):
					Direction(Vector2(1,0),global_position + Vector2(desplazamiento_max,0))
				else:
					Turning(mirando.DER,0);
			elif(Input.is_action_pressed("arriba")):
				if(looking == mirando.ARR):
					Direction(Vector2(0,-1),global_position + Vector2(0,-desplazamiento_max))
				else:
					Turning(mirando.ARR,270);
			elif(Input.is_action_pressed("abajo")):
				if(looking == mirando.ABA):
					Direction(Vector2(0,1),global_position + Vector2(0,desplazamiento_max))
				else:
					Turning(mirando.ABA,90);
		elif(en_movimiento):
			desplazamiento_actual += velocidad * delta;
			if(desplazamiento_actual>=1.0):
				en_movimiento = false;
				global_position = movimiento_final;
				desplazamiento_actual = 0;
				direction = Vector2.ZERO;
			else:
				global_position = movimiento_origen + (desplazamiento_max * direction * desplazamiento_actual)

func Sprint() -> void:
	if(Input.is_action_pressed("sprint")):
		velocidad = velocidad_sprint;
	else:
		velocidad = velocidad_walking;

func Direction(vector : Vector2, final_move : Vector2) -> void:
	if(interaction_detectors.wall_detection()):
		return;
	else:
		direction = vector;
		movimiento_origen = global_position;
		movimiento_final = final_move;
		en_movimiento = true;

func Turning(direc : mirando, rot : int) -> void:
	looking = direc;
	rotation_degrees = rot;
	state = estado.TURNING;
	turn_timer.start();

func _on_turn_timer_timeout() -> void:
	state = estado.IDLE;

func _on_interact_in_chat(objeto):
	in_chat = true
	emit_signal("send_dialogues",objeto.get_conversation());

func _on_main_end_chat():
	in_chat = false
