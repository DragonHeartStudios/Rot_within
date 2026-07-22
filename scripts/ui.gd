extends Control

@onready var dettte: Label = $MarginContainer/header/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/dettte
@onready var energie: ProgressBar = %energie
@onready var h_box_container: HBoxContainer = $MarginContainer/header/MarginContainer/HBoxContainer/HBoxContainer

@onready var jours: Label = $MarginContainer/header/MarginContainer/HBoxContainer/jours
@onready var maps: Button = $MarginContainer/header/MarginContainer/maps
@onready var map: Control = $map
@onready var popup_chois: CenterContainer = $popup_chois
@onready var day_finiched: Control = $day_finiched

@onready var lb_economie: Label = $day_finiched/MarginContainer/VBoxContainer2/lb_economie
@onready var fin: Control = $fin

@onready var sound_map: AudioStreamPlayer = $map/sound_map
@onready var aide_dormir: Control = $aide_dormir
@onready var energie_label: Label = $MarginContainer/header/MarginContainer/HBoxContainer/HBoxContainer/energie/energie_Label

var economie := 0.0
var tween_clignotement: Tween # Variable pour stocker et contrôler notre animation de clignotement

func _ready() -> void:
	GameManager.argent_update.connect(_on_argent_update)
	GameManager.energy_update.connect(_on_energy_update)
	GameManager.day_update.connect(_on_day_update)
	_on_argent_update()
	_on_energy_update()
	_on_day_update()
	popup_chois.visible = false
	day_finiched.visible = false
	fin.visible = false
	map.visible = false
	
	if GameManager.energy <= 0 and GameManager.first_night:
		aide_dormir.show()
		GameManager.first_night = false
	else:
		aide_dormir.hide()
	
func _process(_delta: float) -> void:
	energie.max_value = GameManager.max_energie
	
# affichage de l'argent
func _on_argent_update():
	dettte.text = "%.2f $ / %.2f $ Debt" % [GameManager.argent, GameManager.dette]

func _on_energy_update():
	energie.value = GameManager.energy
	energie_label.text = str(GameManager.energy)
	
	# --- SYSTÈME DE CLIGNOTEMENT ---
	if GameManager.energy <= 0:
		# Si l'animation ne tourne pas déjà, on la lance
		if tween_clignotement == null or not tween_clignotement.is_running():
			_lancer_clignotement()
	else:
		# Si l'énergie est revenue, on arrête le clignotement et on remet la barre opaque
		if tween_clignotement != null:
			tween_clignotement.kill() # Détruit l'animation en cours
		h_box_container.modulate.a = 1.0 # Remet l'opacité normale à 100%

func _lancer_clignotement():
	# On crée un nouveau Tween
	tween_clignotement = create_tween()
	
	# On lui dit de boucler à l'infini
	tween_clignotement.set_loops()
	
	# Étape 1 : On descend l'opacité (alpha) à 0.2 en 0.4 seconde
	tween_clignotement.tween_property(h_box_container, "modulate:a", 0.2, 0.4)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
		
	# Étape 2 : On remonte l'opacité à 1.0 en 0.4 seconde
	tween_clignotement.tween_property(h_box_container, "modulate:a", 1.0, 0.4)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

func _on_day_update():
	#chaque matin...
	jours.text = str("Day ",GameManager.day,"/",GameManager.echeance)#on actuallise le jours
	economie = GameManager.argent #on actuallise l'economie
	lb_economie.text = "%.2f $" % GameManager.argent
	GameManager.salair_brute = 0.0 #on reinitialise le salaire brute
	GameManager.prix_des_ingredient = 0.0
	GameManager.client_pas_content = 0

func _on_maps_pressed() -> void:
	map.visible = true
	sound_map.play()

#func _input(_event: InputEvent) -> void:#cheat !!!!!!!!!!!!!!!
	#if Input.is_action_just_pressed("interact"):
		#GameManager.energy -= 10

func _on_ok_pressed() -> void:
	aide_dormir.hide()
	
#func _process(_delta: float) -> void:# débug
	## Récupère le composant UI actuellement survolé par la souris
	#var objet_survole = get_viewport().gui_get_hovered_control()
	#
	#if objet_survole:
		#print("La souris touche l'UI : ", objet_survole.name, " (Type: ", objet_survole.get_class(), ")")
	#else:
		#print("La souris ne touche aucun élément d'UI")
