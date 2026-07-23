class_name UpgradePanel
extends Panel

# --- Signaux (Optionnel mais très pratique) ---
# Permet de prévenir d'autres scripts qu'une amélioration a été achetée
signal upgrade_applied(valeur_a_changer: String, new_value: int)

# --- Nœuds UI ---
@onready var titre_label: Label = $titre_Label
@onready var image_TextureRect: TextureRect = $MarginContainer/HBoxContainer/image
@onready var lvl_progress_bar: ProgressBar = $MarginContainer/HBoxContainer/lvl_ProgressBar
@onready var lvl_label: Label = $MarginContainer/HBoxContainer/lvl_ProgressBar/lvl_Label
@onready var price_Label: Label = $MarginContainer/HBoxContainer/price
@onready var buy_Button: Button = $MarginContainer/HBoxContainer/buy
@onready var upgrade_sound: AudioStreamPlayer = $upgrade_sound


# --- Configuration de l'Upgrade ---
@export var titre : String
@export var image : Texture
@export var price : int = 100
@export var lvl_max : int = 5	

@export_subgroup("valeur")
@export var valeur_a_lvl_zero : int = 20
@export var valeur_a_lvl_max : int = 50

#Le nom exact de la variable à modifier dans le GameManager (ex: "energie", "vitesse")
@export var valeur_a_changer : String = "energie"

var value : int = 0
var lvl : int = 0

func _ready() -> void:
	titre_label.text = titre
	image_TextureRect.texture = image
	
	# Sécurité : on s'assure que la barre de progression a le bon maximum
	lvl_progress_bar.max_value = lvl_max 
	
	# On initialise la valeur de base au niveau 0
	value = valeur_a_lvl_zero
	update_ui()
	
func update_ui():
	lvl_progress_bar.value = lvl
	lvl_label.text = str("LVL ", lvl, "/", lvl_max)
	price_Label.text = str("-", price, " XP")

func spawn_effect():
	var effect = preload("res://scenes/confetti.tscn").instantiate()
	buy_Button.add_child(effect)

	effect.position = buy_Button.size / 2.0

	await get_tree().create_timer(1.0).timeout

	effect.queue_free()
	
func _on_buy_pressed() -> void:
	if GameManager.xp < price or lvl >= lvl_max:
		return
		
	#confetti
	spawn_effect()
	upgrade_sound.play()
	# 1. Paiement et montée en niveau
	GameManager.xp -= price
	lvl += 1
	price += 15
	
	# 2. Calcul mathématique de la nouvelle valeur (Lerp)
	# On convertit en float pour avoir un chiffre à virgule (ex: 3.0 / 5.0 = 0.6 soit 60%)
	var ratio : float = float(lvl) / float(lvl_max)
	
	# On calcule la valeur entre le min et max selon ce ratio, et on repasse en entier (int)
	value = int(lerp(float(valeur_a_lvl_zero), float(valeur_a_lvl_max), ratio))
	
	update_ui()
	
	# 3. Application modulaire du buff !
	# Si la variable écrite dans l'inspecteur existe bien dans le GameManager, on la met à jour.
	if valeur_a_changer in GameManager:
		GameManager.set(valeur_a_changer, value)
		print("Amélioration appliquée : ", valeur_a_changer, " passe à ", value)
	else:
		push_warning("Attention, la stat '" + valeur_a_changer + "' n'existe pas dans le GameManager !")
		
	# On émet aussi le signal au cas où d'autres scripts voudraient réagir (ex: jouer un son)
	upgrade_applied.emit(valeur_a_changer, value)
	
	
func get_next_value() -> int:
	var next_lvl = min(lvl + 1, lvl_max)
	var ratio = float(next_lvl) / float(lvl_max)
	return int(lerp(float(valeur_a_lvl_zero), float(valeur_a_lvl_max), ratio))

#animation over
@export var scale_hover: Vector2 = Vector2(1.05, 1.05) # +5% de taille
@export var duration: float = 0.15

var tween: Tween

func _notification(what: int) -> void:
	match what:
		# Détecté automatiquement quand la souris entre
		NOTIFICATION_MOUSE_ENTER:
			pivot_offset = size / 2.0 # Recentre le pivot au survol
			_animate_scale(scale_hover)
			
		# Détecté automatiquement quand la souris sort
		NOTIFICATION_MOUSE_EXIT:
			_animate_scale(Vector2.ONE)

# Fonction d'animation réutilisable
func _animate_scale(target_scale: Vector2) -> void:
	if tween:
		tween.kill()
		
	tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", target_scale, duration)
