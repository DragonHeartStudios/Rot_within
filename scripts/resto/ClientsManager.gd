extends Control

@onready var h_box_container: HBoxContainer = $HBoxContainer

# On précharge la scène du client
const CLIENT_SCENE = preload("res://scenes/resto/clients_base.tscn")

# --- VARIABLES EXPORTÉES (Modifiables dans l'inspecteur) ---
@export var max_clients: int = 3                # Nombre max de clients en même temps
@export var temps_verification: float = 1.0     # Temps (en secondes) entre chaque vérification

func _ready() -> void:
	# 1. On crée le Timer par code
	var verif_timer = Timer.new()
	verif_timer.wait_time = temps_verification  # Utilise la variable exportée !
	verif_timer.autostart = true
	add_child(verif_timer)
	
	# 2. On connecte le Timer à la fonction
	verif_timer.timeout.connect(_verifier_et_ajouter_client)
	
	# 3. On lance une première vérification au démarrage
	_verifier_et_ajouter_client()

func _verifier_et_ajouter_client() -> void:
	# On compte combien il y a de clients actuellement
	var nb_clients_actuels = h_box_container.get_child_count()
	
	# Si on a moins que le max autorisé, on en rajoute un
	if nb_clients_actuels < max_clients:
		var nouveau_client = CLIENT_SCENE.instantiate()
		h_box_container.add_child(nouveau_client)
		print("Un nouveau client est apparu ! Nombre total : ", h_box_container.get_child_count())
