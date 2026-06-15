extends Control

@onready var lb_argent: Label = $lb_argent

var argent : float = 25.50:
	set(nouvelle_valeur):
		argent = nouvelle_valeur # 1. On applique le changement de valeur
		update_argent()                 # 2. On appelle ta fonction !
	

func _ready() -> void:
	update_argent()
	
func update_argent():
	lb_argent.text = str(argent,"€")
