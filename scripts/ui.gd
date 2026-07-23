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
var tween_clignotement: Tween

# --- AFFICHAGE DE L'ARGENT ET ANIMATION ---
@export var animation_duration: float = 0.8
@export var custom_curve: Curve

var start_argent: float = 0.0
var target_argent: float = 0.0
var display_argent: float = 0.0

var start_dette: float = 0.0
var target_dette: float = 0.0
var display_dette: float = 0.0

var tween: Tween


func _ready() -> void:
	# 1. On synchronise directement le texte AVANT d'écouter les signaux
	display_argent = GameManager.argent
	target_argent = GameManager.argent
	display_dette = GameManager.dette
	target_dette = GameManager.dette
	_update_text()

	# 2. On connecte les signaux
	GameManager.argent_update.connect(_on_argent_update)
	GameManager.energy_update.connect(_on_energy_update)
	GameManager.day_update.connect(_on_day_update)
	
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
	energie.max_value = GameManager.max_energy


func _on_energy_update() -> void:
	energie.value = GameManager.energy
	energie_label.text = str(GameManager.energy)
	
	# --- SYSTÈME DE CLIGNOTEMENT ---
	if GameManager.energy <= 0:
		if tween_clignotement == null or not tween_clignotement.is_running():
			_lancer_clignotement()
	else:
		if tween_clignotement != null:
			tween_clignotement.kill()
		h_box_container.modulate.a = 1.0


func _lancer_clignotement() -> void:
	tween_clignotement = create_tween()
	tween_clignotement.set_loops()
	
	tween_clignotement.tween_property(h_box_container, "modulate:a", 0.2, 0.4)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
		
	tween_clignotement.tween_property(h_box_container, "modulate:a", 1.0, 0.4)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)


func _on_day_update() -> void:
	jours.text = str("Day ", GameManager.day, "/", GameManager.echeance)
	economie = GameManager.argent
	lb_economie.text = "%.2f $" % GameManager.argent
	GameManager.salair_brute = 0.0
	GameManager.prix_des_ingredient = 0.0
	GameManager.client_pas_content = 0


func _on_maps_pressed() -> void:
	map.visible = true
	sound_map.play()


func _on_ok_pressed() -> void:
	aide_dormir.hide()


# --- ANIMATION DE L'ARGENT ET DE LA DETTE ---
func _on_argent_update() -> void:
	# Sécurité : Si l'argent et la dette n'ont pas changé (ex: au chargement), on n'anime PAS
	if display_argent == GameManager.argent and display_dette == GameManager.dette:
		return

	if tween:
		tween.kill()
		
	start_argent = display_argent
	target_argent = GameManager.argent
	
	start_dette = display_dette
	target_dette = GameManager.dette
	
	tween = create_tween()
	tween.tween_method(_update_step, 0.0, 1.0, animation_duration)


func _update_step(progress: float) -> void:
	var weight = custom_curve.sample(progress) if custom_curve else progress
	
	display_argent = lerp(start_argent, target_argent, weight)
	display_dette = lerp(start_dette, target_dette, weight)
	
	_update_text()


func _update_text() -> void:
	dettte.text = "%.2f $ / %.2f $ Debt" % [display_argent, display_dette]
