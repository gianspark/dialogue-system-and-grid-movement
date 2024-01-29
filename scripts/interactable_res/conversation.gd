extends Resource

class_name Conversation

@export var dialogo : Array[Dialogue]

#retorna la posicion en el array del dialogo
#apunta, POR EJEMPLO

#DIALOGO 1 ES (ID=0) Y APUNTA A DIALOGO 2 (ID=1)

func find_by_id(id : int) -> int:
	for i in dialogo.size():
		if(dialogo[i].id == id):
			return i;
	return 0;
