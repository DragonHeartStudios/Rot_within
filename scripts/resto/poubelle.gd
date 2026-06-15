extends TextureRect # Remplace par Panel si ton nœud est un Panel

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	# On vérifie si ce qu'on glisse possède des groupes (donc que c'est bien un aliment ou un plat)
	if data is TextureRect and data.has_method("get_groups"):
		var groupes = data.get_groups()
		# Si l'objet appartient à au moins un groupe (ex: tomate, salade, ou même un plat préparé), on accepte
		return groupes.size() > 0
		
	return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	# 1. On récupère le slot d'où vient l'ingrédient
	var old_slot = data.get_parent()
	
	# 2. Si l'ingrédient venait d'un slot d'inventaire, on dit à ce slot qu'il est maintenant vide
	if old_slot and old_slot.has_method("remove_item"):
		old_slot.remove_item()
	
	# 3. On détruit proprement et définitivement la tomate/salade/plat de la mémoire du jeu
	data.queue_free()
	
	print("L'objet a été jeté à la poubelle ! 🗑️")
