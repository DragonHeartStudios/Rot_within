extends TextureRect

# Cette fonction se déclenche automatiquement quand on commence à glisser l'objet
func _get_drag_data(at_position: Vector2) -> Variant:
	# 1. On crée un aperçu visuel qui va suivre le curseur
	var preview = TextureRect.new()
	preview.texture = texture
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.custom_minimum_size = size
	
	# On peut légèrement baisser l'opacité de l'aperçu pour le style
	preview.modulate.a = 0.6 
	
	# On dit à Godot d'utiliser cet aperçu
	set_drag_preview(preview)
	
	# 2. On renvoie l'objet lui-même pour que le slot sache ce qu'il reçoit
	return self
