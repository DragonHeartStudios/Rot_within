extends TextureRect

@onready var nom: Label = $nom
@onready var lb_command: Label = $bull/LB_command
@onready var timer: TextureProgressBar = $timer
@onready var resto: Control = $"../../.."
@onready var départe: AudioStreamPlayer = $départe

var noms_clients: Array = ["Hugo", "Alice", "Thomas", "Sarah", "Lucas", "Emma"]
# /!\ ATTENTION : Ces noms doivent correspondre EXACTEMENT aux noms des groupes des plats préparés
var commands_clients: Array = ["burger", "omelette_fromage", "salade mixte", "sandwich"]

@export var vitesse_timer: float = 5.0
var valeur_max: float = 100.0
var en_attente: bool = true
var command = ""

func _ready() -> void:
	
	vitesse_timer = randi_range(vitesse_timer-1, vitesse_timer+1)
	
	var nom_aleatoire = noms_clients.pick_random()
	nom.text = nom_aleatoire
	
	var commands_aleatoire = commands_clients.pick_random()
	command = commands_aleatoire
	lb_command.text = command
	
	# Configuration de la barre
	timer.step = 0.01          
	timer.max_value = valeur_max 
	timer.value = 0.0          
	
	# SÉCURITÉ : On s'assure que le client détecte bien la souris pour le Drop
	mouse_filter = Control.MOUSE_FILTER_PASS

func _process(delta: float) -> void:
	if en_attente:
		timer.value += vitesse_timer * delta
		
		if timer.value >= timer.max_value:
			temps_ecoule()

func temps_ecoule() -> void:
	en_attente = false
	print("Le client ", nom.text, " est parti parce que c'était trop long ! 😢")
	queue_free() # Le client disparaît du jeu

# --- LE SYSTÈME DE LIVRAISON (DRAG & DROP) ---

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	# Si le client attend toujours et qu'on lui amène un TextureRect (un plat)
	if en_attente and data is TextureRect and data.has_method("get_groups"):
		# On autorise le joueur à lâcher l'objet sur le client
		return true
	return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	# 1. On récupère le groupe du plat préparé que le joueur vient de lâcher
	var groupes_du_plat = data.get_groups()
	
	if groupes_du_plat.size() > 0:
		var nom_du_plat = groupes_du_plat[0].to_lower()
		
		# 2. ON VÉRIFIE SI C'EST LE BON PLAT !
		if nom_du_plat == command.to_lower():
			# C'est la bonne commande !
			en_attente = false
			print("Miam ! ", nom.text, " a reçu son ", command, ". Il est super content !  (+$10)")
			resto.argent += 10
			# On détruit le plat préparé puisqu'il est mangé
			data.queue_free()
			
			# On libère le slot d'où venait le plat (si il venait de la planche ou d'un slot)
			var old_slot = data.get_parent()
			if old_slot and old_slot.has_method("remove_item"):
				old_slot.remove_item()
				
			# Le client s'en va joyeux
			queue_free()
		else:
			# Ce n'est pas ce qu'il a demandé !
			print("Beurk ! ", nom.text, " voulait un ", command, " et pas un ", nom_du_plat, " !")
			en_attente = false
			print("Le client ", nom.text, " est parti parce que Ce n'est pas ce qu'il a demandé ! 😢")
			départe.play()
			
			# 1. On crée le timer
			var timer = Timer.new()
			timer.wait_time = 0.6
			timer.one_shot = true # Sécurité : il ne se déclenche qu'une seule fois
			# 2. TRÈS IMPORTANT : On l'ajoute à la scène pour qu'il puisse tourner
			add_child(timer)
			# 3. On le lance et on attend
			timer.start()
			await timer.timeout
			# 4. Le client s'en va !
			queue_free()
			
