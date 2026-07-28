extends TextureRect

# 1. ON PRÉCHARGE LE SHADER
# (Ajuste le chemin vers ton fichier .gdshader s'il est enregistré ailleurs)
const OUTLINE_SHADER = preload("res://resources/shaders/outline2D_outer.gdshader")

# Variable pour stocker le matériau unique de cet objet
var shader_material : ShaderMaterial

# Le nom affiché dans l'infobulle vient du groupe de l'objet. Comme le groupe
# est un identifiant interne (il sert aussi aux recettes), on le convertit ici
# en clé de traduction au lieu de l'afficher tel quel.
const CLES_DES_OBJETS := {
	"Tomato": "ING_TOMATO",
	"Lettuce": "ING_LETTUCE",
	"Cucumber": "ING_CUCUMBER",
	"Egg": "ING_EGG",
	"Cheese": "ING_CHEESE",
	"Raw Patty": "ING_RAW_PATTY",
	"Cooked Patty": "ING_COOKED_PATTY",
	"baguette": "ING_BAGUETTE",
	"Buns": "ING_BUNS",
	"Burger": "DISH_BURGER",
	"Cheese omelette": "DISH_CHEESE_OMELETTE",
	"Mixed salad": "DISH_MIXED_SALAD",
	"sandwich": "DISH_SANDWICH",
}

# Version radioactive. On ne colle pas un simple préfixe "Radioactive " devant :
# l'adjectif s'accorde en genre dans plusieurs langues (tomate radioactivE mais
# œuf radioactiF), donc chaque variante a sa propre clé.
const CLES_DES_OBJETS_RADIOACTIFS := {
	"Tomato": "ING_RADIOACTIVE_TOMATO",
	"Egg": "ING_RADIOACTIVE_EGG",
	"Cooked Patty": "ING_RADIOACTIVE_PATTY",
	"Burger": "DISH_RADIOACTIVE_BURGER",
	"Cheese omelette": "DISH_RADIOACTIVE_CHEESE_OMELETTE",
	"Mixed salad": "DISH_RADIOACTIVE_MIXED_SALAD",
	"sandwich": "DISH_RADIOACTIVE_SANDWICH",
}

func _ready() -> void:
	# 2. ON CRÉE LE MATÉRIAU PAR CODE
	shader_material = ShaderMaterial.new()
	shader_material.shader = OUTLINE_SHADER
	
	# 3. ON APPLIQUE LE MATÉRIAU SUR CE TEXTURERECT
	material = shader_material
	
	# Sécurité : On s'assure que l'objet détecte bien la souris
	mouse_filter = Control.MOUSE_FILTER_PASS
	
	# On éteint l'outline au démarrage
	_modifier_outline(0.0)
	
	var is_radioactive = is_in_group("Radioactive")
	var nom
	
	for group in get_groups():
		if group != "Radioactive":
			nom = group
			break
	
	var table = CLES_DES_OBJETS_RADIOACTIFS if is_radioactive else CLES_DES_OBJETS
	# Si le groupe n'est pas répertorié, on retombe sur son nom brut : la teinte
	# verte suffit déjà à signaler qu'un objet est radioactif.
	var cle = table.get(nom, CLES_DES_OBJETS.get(nom, ""))

	if is_radioactive:
		modulate = Color(0.562, 0.828, 0.0, 1.0)

	tooltip_text = tr(cle) if cle != "" else str(nom)

# Cette fonction se déclenche automatiquement quand on commence à glisser l'objet
func _get_drag_data(_at_position: Vector2) -> Variant:
	_modifier_outline(0.0)
	
	var preview = TextureRect.new()
	preview.texture = texture
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.custom_minimum_size = size
	preview.modulate.a = 0.6 
	
	set_drag_preview(preview)
	return self

# --- DÉTECTION DE LA SOURIS ---

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_MOUSE_ENTER:
			# La souris touche l'objet -> Outline activé (ex: 1.5 pixels)
			_modifier_outline(1.5)
		NOTIFICATION_MOUSE_EXIT:
			# La souris quitte l'objet -> Outline désactivé
			_modifier_outline(0.0)

# Fonction pour changer la variable du shader
func _modifier_outline(epaisseur: float) -> void:
	if shader_material:
		# Pense à remplacer "line_thickness" par le nom exact de ta variable dans ton shader !
		shader_material.set_shader_parameter("line_thickness", epaisseur)
