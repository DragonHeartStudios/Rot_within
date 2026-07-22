extends Control

@onready var shop: MarginContainer = %shop
@onready var ui: Control = $UI
@onready var radioactife: VBoxContainer = %radioactife
@onready var fond_noire: ColorRect = $fond_noire
@onready var start_service: Button = $start_service
@onready var clients: Control = $clients
@onready var click_button_sound: AudioStreamPlayer = $start_service/click_button_sound
@onready var upgrade: MarginContainer = %upgrade


func _process(_delta: float) -> void:

	if start_service.visible == false:
		if shop.visible or upgrade.visible:
			fond_noire.visible = true
		else:
			fond_noire.visible = false
		
	radioactife.visible = GameManager.ingr_radioactive


# On précharge le shader une seule fois ici
const OUTLINE_SHADER = preload("res://resources/shaders/outline2D_outer.gdshader")

func _ready() -> void:
	# On attend un micro-instant que tout le monde soit bien chargé dans le jeu
	if not is_inside_tree():
		await  tree_entered

	await get_tree().process_frame
	
	fond_noire.show()
	start_service.show()
	ui.visible = true
	shop.visible = false
	upgrade.visible = false

	# On récupère TOUS les objets qui sont dans le groupe "avec_outline"
	var objets_a_outline = get_tree().get_nodes_in_group("avec_outline")
	
	for objet in objets_a_outline:
		if objet is Control: # On s'assure que c'est un objet d'interface (TextureRect, Panel, Button...)
			
			# 1. On lui crée et applique son matériau unique
			var mat = ShaderMaterial.new()
			mat.shader = OUTLINE_SHADER
			objet.material = mat
			
			# On éteint l'outline par défaut
			mat.set_shader_parameter("line_thickness", 0.0)
			
			# 2. MAGIE : On connecte les signaux de la souris par code !
			# Pas besoin que l'objet ait un script, on le contrôle à distance.
			objet.mouse_entered.connect(_on_objet_mouse_entered.bind(mat))
			objet.mouse_exited.connect(_on_objet_mouse_exited.bind(mat))


# Quand la souris entre sur N'IMPORTE QUEL objet du groupe
func _on_objet_mouse_entered(mat: ShaderMaterial) -> void:
	if mat:
		mat.set_shader_parameter("line_thickness", 6.0) # On allume

# Quand la souris sort
func _on_objet_mouse_exited(mat: ShaderMaterial) -> void:
	if mat:
		mat.set_shader_parameter("line_thickness", 0.0) # On éteint


func _on_start_service_pressed() -> void:
	start_service.hide()
	clients.max_clients = 3
	click_button_sound.play()
	clients._verifier_et_ajouter_client()
	var tween = create_tween()
	if GameManager.first_service:
		tween.tween_property(GameManager, "temps_verification", 4.0, 30.0).set_trans(Tween.TRANS_LINEAR)
		GameManager.first_service= false
	if GameManager.first_service == false:
		GameManager.temps_verification = 4.0
