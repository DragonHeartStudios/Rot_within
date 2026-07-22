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

func _on_buy_pressed() -> void:
	if GameManager.xp < price or lvl >= lvl_max:
		return
		
	# 1. Paiement et montée en niveau
	GameManager.xp -= price
	lvl += 1
	price += 25
	
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
