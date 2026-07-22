extends Control

# On cible les enfants
@onready var rich_text_label: RichTextLabel = $lettre/RichTextLabel
@onready var lettre: TextureRect = $lettre
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var est_sur_le_dos: bool = false

@export_multiline var text1: String = ""
@export_multiline var text2: String = ""

func _ready() -> void:
	# Sécurité : On configure le pivot de la lettre parfaitement en son centre 
	# (basé sur la taille de l'image elle-même)
	lettre.pivot_offset = lettre.size / 2.0
	
	# On applique le texte de départ
	rich_text_label.text = "[center]" + text1 + "[/center]"

func retourner_la_feuille() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	# 1. On anime l'échelle de l'image de la lettre jusqu'à 0 (sur sa tranche)
	tween.tween_property(lettre, "scale:x", 0.0, 0.2)
	
	# 2. Changement de texte au milieu de l'animation (quand la feuille est invisible)
	tween.tween_callback(func():
		est_sur_le_dos = not est_sur_le_dos
		
		if est_sur_le_dos:
			rich_text_label.text = "[center]" + text2 + "[/center]"
			# On applique l'ombre uniquement sur l'image de la lettre
			lettre.modulate = Color(0.85, 0.85, 0.85) 
		else:
			rich_text_label.text = "[center]" + text1 + "[/center]"
			lettre.modulate = Color.WHITE
	)
	
	# 3. L'image de la lettre se réouvre de façon fluide
	tween.tween_property(lettre, "scale:x", 1.0, 0.2)


func _on_button_pressed() -> void:
	retourner_la_feuille()
	audio_stream_player.play()


func _on_close_pressed() -> void:
	queue_free()
