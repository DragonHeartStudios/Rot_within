extends Control

@onready var popup_chois: CenterContainer = $"../popup_chois"

@onready var lb_salaire_de_base: Label = $MarginContainer/VBoxContainer2/lb_salaire_de_base
@onready var lb_economie: Label = $MarginContainer/VBoxContainer2/lb_economie
@onready var lb_loyer: Label = $MarginContainer/VBoxContainer2/lb_loyer
@onready var lb_prix_des_ingredient: Label = $MarginContainer/VBoxContainer2/lb_prix_des_ingredient
@onready var lb_client_pas_content: Label = $MarginContainer/VBoxContainer2/lb_client_pas_content

@onready var sound_day_finish: AudioStreamPlayer = $"../sound_day_finish"

# Remplace totale par un RichTextLabel dans l'éditeur pour le BBCode !
@onready var totale: RichTextLabel = $MarginContainer/totale 
@onready var fin: Control = $"../fin"

func _ready() -> void: 
	GameManager.energy_update.connect(day_finished)

func day_finished() -> void:
	if GameManager.energy == 0.0:
		GameManager.preparer_journee_suivante()
		# 1. ON ENREGISTRE L'ÉCONOMIE DU MATIN (à faire au début de la journée dans ton jeu)
		# Pour l'exemple, on imagine que lb_economie a été rempli ce matin.
		var argent_ce_matin : float = float(lb_economie.text.replace(" $", "")) 
		
		# 2. APPLICATION DES SOUSTRACTIONS SUR LE COMPTE
		GameManager.argent -= 10.0 # Loyer
		GameManager.argent -= GameManager.client_pas_content # Pénalités clients
		
		# 3. AFFICHAGE DES TEXTES (Optionnel : tu peux aussi appliquer le formatage ici si besoin)
		lb_salaire_de_base.text = str(GameManager.salair_brute, " $")
		lb_prix_des_ingredient.text = str(GameManager.prix_des_ingredient, " $")
		lb_client_pas_content.text = str("-", GameManager.client_pas_content, " $")
		
		# 4. CALCUL DU TOTAL GAGNÉ AUJOURD'HUI (Aujourd'hui - Ce matin)
		var total_gagne_aujourdhui  = GameManager.argent - argent_ce_matin
		
		# --- LA CORRECTION DU FORMATAGE ---
		# On transforme le float moche en une belle chaîne de caractères propre (ex: "45.45")
		var total_propre = "%.2f" % total_gagne_aujourdhui
		
		# Couleur dynamique du Total (Vert si positif, Rouge si négatif)
		var couleur_total = "green"
		if total_gagne_aujourdhui < 0:
			couleur_total = "red"
			
		# On utilise 'total_propre' à la place de 'total_gagne_aujourdhui' pour le texte
		totale.text = str("Total : [color=", couleur_total, "]", total_propre, " $[/color]")
			
		# 5. SYSTÈME DES FINS (Ton arborescence de choix est super !)
		if GameManager.argent <= 0:
			GameManager.ending = "ruinne"
			fin.visible = true
			
		elif GameManager.day == GameManager.echeance:
			fin.visible = true
			print(GameManager.hight_score_mutant)
			if GameManager.hight_score_mutant >= 1.0:
				GameManager.ending = "apocalypse"
				return
			if GameManager.argent >= GameManager.dette:
				if GameManager.honnetete > 0:
					GameManager.ending = "true_ending"
				else:
					GameManager.ending = "demon"
			else:
				GameManager.ending = "prison"
				
		else:
			# Si on n'est pas ruiné et que ce n'est pas l'échéance, on montre le reçu
			fin.visible = false
			visible = true
			sound_day_finish.play()

func _on_suivant_button_up() -> void:
	visible = false
	popup_chois.visible = true
