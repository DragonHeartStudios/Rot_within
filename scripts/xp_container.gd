extends HBoxContainer
@onready var xp: Label = %xp


func _process(delta: float) -> void:
	xp.text = str(GameManager.xp)
	
