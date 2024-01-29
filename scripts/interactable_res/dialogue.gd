extends Resource

class_name Dialogue

#creo una id para el dialogo
@export var id : int = 0;
#esto es para que uno de los dialogos apunte hacia
#un dialogo en concreto si no tengo opcion
@export var id_to_next : int = -1;
@export var messages : Array[Message];

#esto verifica si hay opciones validas.
func check_options(num : int) -> bool:
	if(num >= messages.size()):
		return true
	return messages[num].check_options()

#esto verifica si el dialogo continua
#en el caso de ser -1 no se continua
func valid_end() -> bool:
	if(id_to_next == -1):
		return true;
	else:
		return false;
