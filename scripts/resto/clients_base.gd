extends Control

@onready var nom: Label = $nom
@onready var lb_command: Label = $bull/HBoxContainer/LB_command
@onready var timer: TextureProgressBar = $timer
@onready var resto: Control = $"../../.."
@onready var départe: AudioStreamPlayer = $départe
@onready var bonne_command: AudioStreamPlayer = $bonne_command
@onready var h_box_container: HBoxContainer = $bull/HBoxContainer

# --- CHANGEMENT DE NOEUD VISUEL ---
# On remplace l'ancien TextureRect par ton AnimatedSprite2D
@onready var animated_sprite: AnimatedSprite2D = $clients_base

# On va chercher le noeud parent direct (le HBoxContainer converti en Control) 
# qui contient le script de gestion de la file fluide
@onready var gestionnaire_file: Control = get_parent().get_parent()

@onready var burger: TextureRect = $bull/HBoxContainer/Control/burger
@onready var omelette_fromage: TextureRect = $bull/HBoxContainer/Control/omelette_fromage
@onready var salade_mixte: TextureRect = $"bull/HBoxContainer/Control/salade mixte"
@onready var sandwich: TextureRect = $bull/HBoxContainer/Control/sandwich
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# --- CONFIGURATION DU SHADER D'OUTLINE ---
const OUTLINE_SHADER = preload("res://resources/shaders/outline2D_outer.gdshader")
var shader_material : ShaderMaterial

var noms_clients: Array = ["Hugo", "Emena", "Alice", "Talel", "Thomas", "Sarah", "Lucas", "Sacha", "Emma", "Miguel", "Seb", "Melvin", "Jean"]

# --- ENUM DE NOTRE SYSTEME DE MUTATION ---
enum TypeClient { NORMAL, MONSTRE }
var type_actuel: TypeClient = TypeClient.NORMAL

# --- LE COIN DES PRIX ---
var commands_clients: Dictionary = {
	"burger": 15,
	"cheese omelette": 7.5,
	"mixed salad": 11,
	"sandwich": 13.5
}

@export var vitesse_timer: float = 5.0
var valeur_max: float = 100.0
var en_attente: bool = true
var command = ""
var prix_de_la_commande : int = 0 

func _ready() -> void:
	randomize()
	# 1. Sélection de l'apparence via AnimatedSprite2D
	var toutes_les_animations = Array(animated_sprite.sprite_frames.get_animation_names())
	var client_au_pif = toutes_les_animations.pick_random()
	animated_sprite.animation = client_au_pif
	animated_sprite.stop()
	# 2. Application de la probabilité de mutation (basée sur la journée précédente)
	var jet_de_de = randf()
	if jet_de_de < GameManager.ratio_monstres_demain:
		type_actuel = TypeClient.MONSTRE
		animated_sprite.frame = 1 # Frame 1 = Version Monstre
		# Les monstres s'impatientent BEAUCOUP plus vite (Vitesse augmentée)
		vitesse_timer = vitesse_timer * 2.5 
		print("Un client MONSTRE vient d'arriver ! Sa patience est réduite.")
	else:
		type_actuel = TypeClient.NORMAL
		animated_sprite.frame = 0 # Frame 0 = Version Humaine
		vitesse_timer = randf_range(vitesse_timer-1, vitesse_timer+1)
	
	var nom_aleatoire = noms_clients.pick_random()
	nom.text = nom_aleatoire
	
	var plats_disponibles = commands_clients.keys()
	var commands_aleatoire = plats_disponibles.pick_random()
	
	command = commands_aleatoire
	lb_command.text = command
	prix_de_la_commande = commands_clients[command]
	tooltip_text = command
	match command:
		"burger":
			burger.show()
		"cheese omelette":
			omelette_fromage.show()
		"mixed salad":
			salade_mixte.show()
		"sandwich":
			sandwich.show()
	
	timer.step = 0.01          
	timer.max_value = valeur_max 
	timer.value = 0.0          
	
	mouse_filter = Control.MOUSE_FILTER_PASS
	
	# Configuration de l'outline directement sur l'AnimatedSprite2D
	shader_material = ShaderMaterial.new()
	shader_material.shader = OUTLINE_SHADER
	animated_sprite.material = shader_material
	_modifier_outline(0.0) 
	
	# On applique le filtre sur le Control principal (le client lui-même)
	mouse_filter = Control.MOUSE_FILTER_PASS

	# Connexions des signaux sur le Control principal (self) au lieu de l'AnimatedSprite2D
	mouse_entered.connect(_on_clients_base_mouse_entered)
	mouse_exited.connect(_on_clients_base_mouse_exited)
	#on cree le timer pour la command qui disparait
	await get_tree().create_timer(GameManager.order_speed).timeout
	animation_player.play("new_animation")

func _process(delta: float) -> void:
	if en_attente:
		timer.value += vitesse_timer * delta
		
		if timer.value >= timer.max_value:
			temps_ecoule()

func temps_ecoule() -> void:
	en_attente = false
	print("Le client ", nom.text, " est parti parce que c'était trop long ! 😢")
	GameManager.client_pas_content += 1
	
	if gestionnaire_file and gestionnaire_file.has_method("faire_partir_client"):
		gestionnaire_file.faire_partir_client(self)
	else:
		queue_free()

# --- GESTION VISUELLE DE L'OUTLINE ---

func _on_clients_base_mouse_entered() -> void:
	if en_attente:
		_modifier_outline(10.0)

func _on_clients_base_mouse_exited() -> void:
	_modifier_outline(0.0)

func _modifier_outline(epaisseur: float) -> void:
	if shader_material:
		shader_material.set_shader_parameter("line_thickness", epaisseur)

# --- LE SYSTÈME DE LIVRAISON (DRAG & DROP) ---

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if en_attente and data is TextureRect and data.has_method("get_groups"):
		return true
	return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var groupes_du_plat = data.get_groups()
	
	if groupes_du_plat.size() > 0:
		var nom_du_plat = groupes_du_plat[0].to_lower()
		
		if nom_du_plat == command.to_lower():
			en_attente = false
			_modifier_outline(0.0)
			print("Miam ! ", nom.text, " a reçu son ", command, ". Il est super content ! (+$", prix_de_la_commande, ")")
			
			# --- NOUVEAU : On vérifie si le plat donné est radioactif ---
			if data.is_in_group("Radioactive"):
				# On ajoute +1 au compteur global dans le GameManager
				GameManager.plats_radioactifs_aujourd_hui += 1
				print("Aïe... Le plat servi était radioactif ! Compteur aujourd'hui : ", GameManager.plats_radioactifs_aujourd_hui)
			
			GameManager.argent += prix_de_la_commande
			var xp_gagner = randi_range(8, 15)
			GameManager.xp += xp_gagner
			GameManager.salair_brute += prix_de_la_commande
			GameManager.energy -= GameManager.fatigue
			
			bonne_command.play()
			
			#effect text qui montre l'argant qu'on a gagenr
			var argent_scene = preload("res://scenes/argent_gagner.tscn")
			var argent_lb = argent_scene.instantiate()
			argent_lb.text = str("+ ", prix_de_la_commande, " $")
			argent_lb.modulate = Color.YELLOW
			argent_lb.rotation_degrees = -8.0
			add_child(argent_lb)
			
			#effect text qui montre l'XP qu'on a gagenr
			var xp_scene = preload("res://scenes/argent_gagner.tscn")
			var xp_lb = xp_scene.instantiate()
			xp_lb.text = str("+", xp_gagner, " XP")
			xp_lb.modulate = Color.GREEN
			xp_lb.rotation_degrees = 8.0
			add_child(xp_lb)
			
			data.queue_free()
			var old_slot = data.get_parent()
			if old_slot and old_slot.has_method("remove_item"):
				old_slot.remove_item()
				
			await get_tree().create_timer(0.6).timeout
			
			if gestionnaire_file and gestionnaire_file.has_method("faire_partir_client"):
				gestionnaire_file.faire_partir_client(self)
			else:
				queue_free()
			
		else:
			print("Beurk ! ", nom.text, " voulait un ", command, " et pas un ", nom_du_plat, " !")
			en_attente = false
			_modifier_outline(0.0)
			print("Le client ", nom.text, " est parti parce que Ce n'est pas ce qu'il a demandé ! 😢")
			départe.play()
			GameManager.client_pas_content += 1
			GameManager.energy -= GameManager.fatigue
			
			await get_tree().create_timer(0.6).timeout
			
			if gestionnaire_file and gestionnaire_file.has_method("faire_partir_client"):
				gestionnaire_file.faire_partir_client(self)
			else:
				queue_free()
