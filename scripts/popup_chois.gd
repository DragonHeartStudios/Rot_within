extends CenterContainer

signal choix_effectue(id_choix: int, texte_choix: String)

@onready var lb_question: RichTextLabel = $panel/MarginContainer/Label
@onready var hbox_reponses: HBoxContainer = $panel/HBoxContainer

# --- LES ÉVÉNEMENTS EXCLUSIFS DE "ROT WITHIN" ENRICHIS --- ne surout pas mettre mois d'evenement que le nombre de l'échéence sinon bug
# "question" et "choix" contiennent des clés de traduction : le vrai texte de
# chaque langue se trouve dans scripts/Localization.gd.
const EVENEMENTS_DU_JEU = {
	1: {
		"question": "EVENT_1_Q",
		"choix": [
			"EVENT_1_A1",
			"EVENT_1_A2"
		],
		"consequences": [
			{"argent": 50.0, "honnetete": -2, "dette": 0, "fatigue": 0, "temps_verification": 4.0, "radioactif": false, "vider_frigo": false},
			{"argent": 0.0, "honnetete": 1, "dette": 0, "fatigue": 0, "temps_verification": 4.0, "radioactif": false, "vider_frigo": false}
		]
	},
	2: {
		"question": "EVENT_2_Q",
		"choix": [
			"EVENT_2_A1",
			"EVENT_2_A2"
		],
		"consequences": [
			{"argent": 20.0, "honnetete": -3, "dette": 0, "fatigue": 0, "temps_verification": 2.5, "radioactif": true, "vider_frigo": false}, 
			{"argent": 0.0, "honnetete": 2, "dette": 0, "fatigue": 0, "temps_verification": 5.0, "radioactif": false, "vider_frigo": false}    
		]
	},
	3: {
		"question": "EVENT_3_Q",
		"choix": [
			"EVENT_3_A1",
			"EVENT_3_A2"
		],
		"consequences": [
			{"argent": 15.0, "honnetete": -2, "dette": 0, "fatigue": 0, "temps_verification": 4.0, "radioactif": false, "vider_frigo": false},
			{"argent": 0.0, "honnetete": 3, "dette": 0, "fatigue": 0, "temps_verification": 4.0, "radioactif": false, "vider_frigo": true}
		]
	},
	4: {
		"question": "EVENT_4_Q",
		"choix": [
			"EVENT_4_A1",
			"EVENT_4_A2"
		],
		"consequences": [
			{"argent": 0.0, "honnetete": -1, "dette": 0, "fatigue": 2, "temps_verification": 4.0, "radioactif": false, "vider_frigo": false},
			{"argent": -50.0, "honnetete": 1, "dette": 0, "fatigue": 0, "temps_verification": 4.0, "radioactif": false, "vider_frigo": false}
		]
	},
	5: {
		"question": "EVENT_5_Q",
		"choix": [
			"EVENT_5_A1",
			"EVENT_5_A2"
		],
		"consequences": [
			{"argent": 0.0, "honnetete": -4, "dette": -50, "fatigue": 0, "temps_verification": 4.0, "radioactif": false, "vider_frigo": false},
			{"argent": 0.0, "honnetete": 2, "dette": 0, "fatigue": 0, "temps_verification": 4.0, "radioactif": false, "vider_frigo": false}
		]
	},
	6: {
		"question": "EVENT_6_Q",
		"choix": [
			"EVENT_6_A1",
			"EVENT_6_A2"
		],
		"consequences": [
			{"argent": 30.0, "honnetete": -2, "dette": 0, "fatigue": 0, "temps_verification": 4.0, "radioactif": false, "vider_frigo": false},
			{"argent": 0.0, "honnetete": 1, "dette": 0, "fatigue": -1, "temps_verification": 4.0, "radioactif": false, "vider_frigo": false}
		]
	},
	7: {
		"question": "EVENT_7_Q",
		"choix": [
			"EVENT_7_A1",
			"EVENT_7_A2"
		],
		"consequences": [
			{"argent": -15.0, "honnetete": 2, "dette": 0, "fatigue": 0, "temps_verification": 5.5, "radioactif": false, "vider_frigo": false},
			{"argent": 0.0, "honnetete": -1, "dette": 0, "fatigue": 0, "temps_verification": 4.0, "radioactif": false, "vider_frigo": false}
		]
	},
	8: {
		"question": "EVENT_8_Q",
		"choix": [
			"EVENT_8_A1",
			"EVENT_8_A2"
		],
		"consequences": [
			{"argent": 0.0, "honnetete": -3, "dette": -10, "fatigue": 0, "temps_verification": 1.5, "radioactif": false, "vider_frigo": false},
			{"argent": 0.0, "honnetete": 1, "dette": 0, "fatigue": 0, "temps_verification": 4.0, "radioactif": false, "vider_frigo": false}
		]
	},
	9: {
		"question": "EVENT_9_Q",
		"choix": [
			"EVENT_9_A1",
			"EVENT_9_A2"
		],
		"consequences": [
			{"argent": 50.0, "honnetete": -5, "dette": 0, "fatigue": 0, "temps_verification": 4.0, "radioactif": false, "vider_frigo": false},
			{"argent": 0.0, "honnetete": 4, "dette": 0, "fatigue": 0, "temps_verification": 4.0, "radioactif": false, "vider_frigo": false}
		]
	},
	10: {
		"question": "EVENT_10_Q",
		"choix": [
			"EVENT_10_A1",
			"EVENT_10_A2"
		],
		"consequences": [
			{"argent": 50.0, "honnetete": -5, "dette": 0, "fatigue": 0, "temps_verification": 4.0, "radioactif": false, "vider_frigo": false},
			{"argent": 0.0, "honnetete": 4, "dette": 0, "fatigue": 0, "temps_verification": 4.0, "radioactif": false, "vider_frigo": false}
		]
	}
}

func _ready() -> void:
	lb_question.bbcode_enabled = true
	charger_question_du_jour()

func charger_question_du_jour() -> void:
	var jour_actuel = GameManager.day
	
	if not EVENEMENTS_DU_JEU.has(jour_actuel):
		print("Pas d'événement prévu pour le jour ", jour_actuel)
		prochain_ecran()
		return
		
	var donnees_evenement = EVENEMENTS_DU_JEU[jour_actuel]
	lb_question.text = tr(donnees_evenement["question"])

	for enfant in hbox_reponses.get_children():
		enfant.queue_free()

	for i in range(donnees_evenement["choix"].size()):
		var cle_du_choix = donnees_evenement["choix"][i]

		var bouton = Button.new()
		bouton.text = tr(cle_du_choix)
		bouton.custom_minimum_size = Vector2(370, 40)
		# Les traductions sont plus longues que l'anglais : on laisse le libellé
		# passer à la ligne plutôt que de déborder du panneau.
		bouton.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		bouton.pressed.connect(_on_choix_bouton_pressed.bind(i, cle_du_choix))

		hbox_reponses.add_child(bouton)

func _on_choix_bouton_pressed(id_choix: int, texte_choix: String) -> void:
	print("Decker a choisi l'option ", id_choix, " : ", texte_choix)
	
	var jour_actuel = GameManager.day
	if EVENEMENTS_DU_JEU.has(jour_actuel):
		var donnees_evenement = EVENEMENTS_DU_JEU[jour_actuel]
		var consequence = donnees_evenement["consequences"][id_choix]
		
		# --- APPLICATION DES NOUVELLES VARIABLES DANS LE GAMEMANAGER ---
		GameManager.argent += consequence["argent"]
		GameManager.honnetete += consequence["honnetete"]
		GameManager.dette += consequence["dette"]
		
		# Empêche la fatigue de descendre en dessous de 0
		GameManager.fatigue = max(1, GameManager.fatigue + consequence["fatigue"])
		
		# Rythme des clients (temps_verification)
		GameManager.temps_verification = consequence["temps_verification"]
		
		# Activation ou non du shop radioactif
		if consequence["radioactif"] == true:
			GameManager.ingr_radioactive = true
			
		# Gestion de la vidange du frigo
		if consequence["vider_frigo"] == true:
			for slot in GameManager.slots_du_frigo.keys():
				GameManager.slots_du_frigo[slot] = "vide"
		
		print("Modifications appliquées - Argent: ", GameManager.argent, " | Dette: ", GameManager.dette, " | Fatigue: ", GameManager.fatigue)

	choix_effectue.emit(id_choix, texte_choix)
	
	for bouton in hbox_reponses.get_children():
		if bouton is Button:
			bouton.disabled = true
	
	await get_tree().create_timer(1.5).timeout
	prochain_ecran()

func prochain_ecran() -> void:
	visible = false
	get_tree().change_scene_to_file("res://scenes/appartement.tscn")
