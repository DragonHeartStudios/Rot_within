extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ui: Control = $UI

# On précharge le shader une seule fois ici
const OUTLINE_SHADER = preload("res://resources/shaders/outline2D_outer.gdshader")

func _ready() -> void:
	# On attend un micro-instant que tout le monde soit bien chargé dans le jeu
	if not is_inside_tree():
		await  tree_entered

	await get_tree().process_frame
	
	animation_player.play("RESET")
	ui.show()
	if GameManager.first_day == true:
		GameManager.first_day = false
		
		var lettre_scn = preload("res://scenes/lettre.tscn")
		var lettre = lettre_scn.instantiate()
		add_child(lettre)
		
		
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

func _on_letter_pressed() -> void:
	var lettre_scn = preload("res://scenes/lettre.tscn")
	var lettre = lettre_scn.instantiate()
	add_child(lettre)

func _on_objet_mouse_entered(mat: ShaderMaterial) -> void:
	if mat:
		mat.set_shader_parameter("line_thickness", 6.0) # On allume

# Quand la souris sort
func _on_objet_mouse_exited(mat: ShaderMaterial) -> void:
	if mat:
		mat.set_shader_parameter("line_thickness", 0.0) # On éteint

func on_dormir_pressed() -> void:
	if GameManager.energy == 0:
		animation_player.play("new_animation")
		await animation_player.animation_finished
		GameManager.energy = GameManager.max_energy
		GameManager.day += 1

func _on_porte_pressed() -> void:
	$UI/map.show()
	$UI/map/sound_map.play()
