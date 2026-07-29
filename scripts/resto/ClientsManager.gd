extends Control

@onready var h_box_container: Control = $HBoxContainer

# On précharge la scène du client
const CLIENT_SCENE = preload("res://scenes/resto/clients_base.tscn")

# --- VARIABLES DE CONFIGURATION ---
var max_clients: int = 0 # c'est que quand on appuis sur commencé le service que les client apparaise et que la varible est difinie a 3
@export var espacement_x: float = 250.0  
@export var position_depart_x: float = 50.0 
@export var position_y: float = 0.0        

func _ready() -> void:
	var verif_timer = Timer.new()
	verif_timer.wait_time = GameManager.temps_verification
	verif_timer.autostart = true
	add_child(verif_timer)

	verif_timer.timeout.connect(_verifier_et_ajouter_client)
	_verifier_et_ajouter_client()

func _verifier_et_ajouter_client() -> void:
	if GameManager.energy == 0:
		return
		
	var nb_clients_actuels = h_box_container.get_child_count()
	
	if nb_clients_actuels < max_clients:
		var nouveau_client = CLIENT_SCENE.instantiate()
		h_box_container.add_child(nouveau_client)
		
		# Position de départ temporaire (tout à droite) avant de glisser à sa place
		nouveau_client.position.y = position_y
		nouveau_client.position.x = position_depart_x + (max_clients * espacement_x)
		nouveau_client.modulate.a = 0.0
		
		actualiser_positions_file()

# --- LA NOUVELLE FONCTION DE DÉPART DYNAMIQUE ---
# Passe le nœud du client directement dans les parenthèses quand il doit partir !
func faire_partir_client(client_qui_part: Node) -> void:
	if not client_qui_part or client_qui_part.get_parent() != h_box_container:
		return
		
	if client_qui_part.has_method("set_process"): 
		client_qui_part.set_process(false)
		
	# 1. On crée un premier tween SIMPLE (pas de parallèle) pour la sortie du client
	var tween_depart = create_tween()
	# On utilise set_parallel ici pour animer la position ET l'opacité en même temps
	tween_depart.set_parallel(true)
	tween_depart.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween_depart.tween_property(client_qui_part, "position:x", client_qui_part.position.x - 150.0, 0.25)
	tween_depart.tween_property(client_qui_part, "modulate:a", 0.0, 0.25)
	
	# 2. Pour éviter l'erreur de "chain()", on connecte un signal propre qui se déclenche à la fin du tween
	tween_depart.finished.connect(func():
		client_qui_part.queue_free()
	)
	
	# 3. On détache immédiatement le client du conteneur sans aucun 'await'
	# Ainsi, sa place est libérée mathématiquement instantanément
	h_box_container.remove_child(client_qui_part)
	
	# 4. On réaligne TOUT DE SUITE les clients restants
	actualiser_positions_file()

func actualiser_positions_file() -> void:
	# S'il n'y a plus aucun client dans la file, on s'arrête immédiatement
	# Cela évite de créer un Tween vide qui fait crasher le jeu !
	if h_box_container.get_child_count() == 0:
		return
		
	# On crée le Tween uniquement si on a des clients à animer
	var tween_file = create_tween().set_parallel(true)
	tween_file.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	for i in range(h_box_container.get_child_count()):
		var client = h_box_container.get_child(i)
		
		var position_cible_exacte = position_depart_x + (i * espacement_x)
		
		tween_file.tween_property(client, "position:x", position_cible_exacte, 0.35)
		tween_file.tween_property(client, "modulate:a", 1.0, 0.35)
