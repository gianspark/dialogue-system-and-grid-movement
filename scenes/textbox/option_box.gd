extends PanelContainer

@onready var texto = $MarginContainer/texto
@onready var borde = $borde

func hide_border():
	borde.hide()

func show_border():
	borde.show()

func set_text(t : String):
	texto.text = t
