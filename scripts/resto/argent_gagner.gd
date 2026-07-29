extends Label

func _ready() -> void:
	# 1. On configure le texte (Exemple : tu pourras changer la valeur depuis le script du client)
	# text = "+ 10 €"
	
	# 2. On crée le Tween magique
	var tween = create_tween()
	
	# On veut que les deux animations (la montée et la transparence) se jouent EN MÊME TEMPS
	tween.set_parallel(true)
	
	# --- ANIMATION 1 : LA MONTÉE ---
	# On dit au Label de monter de 60 pixels vers le haut (négatif en Y) pendant 1.0 seconde
	# .set_trans() et .set_ease() permettent de donner un effet de ralentissement fluide à la fin
	tween.tween_property(self, "position:y", position.y - 60, 1.0)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
		
	# --- ANIMATION 2 : LE DISPARAÎTRE (FADE OUT) ---
	# On change l'opacité (alpha) du texte pour la faire passer à 0 (invisible) en 1.0 seconde
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	
	# --- FIN DE L'ANIMATION ---
	# Une fois que le tween a terminé toutes ses tâches, on détruit automatiquement le Label
	tween.chain().tween_callback(queue_free)
