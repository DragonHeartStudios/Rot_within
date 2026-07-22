extends Control

@onready var ruinne: Control = $ruinne
@onready var prison: Control = $prison
@onready var fin_demon: Control = $fin_demon
@onready var true_ending: Control = $true_ending
@onready var apocalypse: Control = $apocalypse

@onready var argent: RichTextLabel = $HBoxContainer/argent
@onready var honnetete: RichTextLabel = $HBoxContainer/honnetete


func _ready() -> void:
	ruinne.hide()
	prison.hide()
	fin_demon.hide()
	true_ending.hide()
	apocalypse.hide()
	

func _process(_delta: float) -> void:
	
	if visible == true:
		# --- GESTION DE LA COULEUR DE L'ARGENT ---
		var couleur_argent = "green"
		if GameManager.argent < 0:
			couleur_argent = "red"
		# On applique le BBCode pour l'argent

		argent.text = "Money : [color=%s]%.2f $[/color]" % [couleur_argent, GameManager.argent]

		# --- GESTION DE LA COULEUR DE L'HONNÊTETÉ ---
		var couleur_honnetete = "green"
		if GameManager.honnetete < 0:
			couleur_honnetete = "red"
		# On applique le BBCode pour l'honnêteté
		honnetete.text = str("Honestly : [color=", couleur_honnetete, "]", GameManager.honnetete, "[/color]")
	
		var end = GameManager.ending
		# Variable pour stocker l'écran sélectionné
		var ecran_selectionne : CanvasItem = null

		match end:
			"ruinne":
				ecran_selectionne = ruinne
			"prison":
				ecran_selectionne = prison
			"demon":
				ecran_selectionne = fin_demon
			"true_ending":
				ecran_selectionne = true_ending
			"apocalypse":
				ecran_selectionne = apocalypse

		# Si un écran correspond, on lance l'animation de transition
		if ecran_selectionne:
			# 1. On force l'opacité à 0 (invisible) avant de l'afficher
			ecran_selectionne.modulate.a = 0.0
			ecran_selectionne.show()
			
			# 2. On crée le Tween pour animer l'opacité (Alpha)
			var tween = create_tween()
			
			# Anime la propriété "modulate:a" vers 1.0 en 1.5 seconde
			# (Tu peux changer 1.5 par la durée que tu veux, ex: 0.5 pour plus rapide)
			tween.tween_property(ecran_selectionne, "modulate:a", 1.0, 1.5)\
				.set_trans(Tween.TRANS_QUAD)\
				.set_ease(Tween.EASE_OUT)
				
