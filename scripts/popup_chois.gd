extends CenterContainer

signal choix_effectue(id_choix: int, texte_choix: String)

@onready var lb_question: RichTextLabel = $panel/MarginContainer/Label
@onready var hbox_reponses: HBoxContainer = $panel/HBoxContainer

# --- LES ÉVÉNEMENTS EXCLUSIFS DE "ROT WITHIN" ENRICHIS --- ne surout pas mettre mois d'evenement que le nombre de l'échéence sinon bug
const EVENEMENTS_DU_JEU = {
	1: {
		"question": "While cleaning a restaurant table, [b]Decker[/b] finds a forgotten wallet containing [color=yellow]$50[/color]. What do you do?",
		"choix": [
			"Steal money (+$50 | Dishonest)",
			"Put it aside (+1 Honesty)"
		],
		"consequences": [
			{"argent": 50.0, "honnetete": -2, "dette": 0, "fatigue": 0, "temps_verification": 4.0, "radioactif": false, "vider_frigo": false},
			{"argent": 0.0, "honnetete": 1, "dette": 0, "fatigue": 0, "temps_verification": 4.0, "radioactif": false, "vider_frigo": false}
		]
	},
	2: {
		"question": "[b]Henkins[/b] stops by the restaurant and whispers: [i]“Replace the premium ingredients with radioactive ones. Customers won't notice a thing.”[/i]",
		"choix": [
			"Accept deal (Radioactive ON | Fast customers)",
			"Refuse flat out (+2 Honesty | Patient customers)"
		],
		"consequences": [
			{"argent": 20.0, "honnetete": -3, "dette": 0, "fatigue": 0, "temps_verification": 2.5, "radioactif": true, "vider_frigo": false}, 
			{"argent": 0.0, "honnetete": 2, "dette": 0, "fatigue": 0, "temps_verification": 5.0, "radioactif": false, "vider_frigo": false}    
		]
	},
	3: {
		"question": "On your way home, a weak homeless man is sleeping near your building. A [color=yellow]$15[/color] bill is sticking out of his pocket...",
		"choix": [
			"Rob the man (+$15)",
			"Give him leftovers (Empty fridge | +3 Honesty)"
		],
		"consequences": [
			{"argent": 15.0, "honnetete": -2, "dette": 0, "fatigue": 0, "temps_verification": 4.0, "radioactif": false, "vider_frigo": false},
			{"argent": 0.0, "honnetete": 3, "dette": 0, "fatigue": 0, "temps_verification": 4.0, "radioactif": false, "vider_frigo": true}
		]
	},
	4: {
		"question": "A panicked customer returns. She claims you gave her wrong change and demands [color=red]$50[/color]. You know it's a lie.",
		"choix": [
			"Lie aggressively (+ Fatigue)",
			"Refund her (-$50 | Avoid drama)"
		],
		"consequences": [
			{"argent": 0.0, "honnetete": -1, "dette": 0, "fatigue": 2, "temps_verification": 4.0, "radioactif": false, "vider_frigo": false},
			{"argent": -50.0, "honnetete": 1, "dette": 0, "fatigue": 0, "temps_verification": 4.0, "radioactif": false, "vider_frigo": false}
		]
	},
	5: {
		"question": "Henkins' ledger is sitting on the table. You could forge his signature to magically erase part of your debt.",
		"choix": [
			"Forge ledger (-$50 Debt!)",
			"Stay honest with Henkins"
		],
		"consequences": [
			{"argent": 0.0, "honnetete": -4, "dette": -50, "fatigue": 0, "temps_verification": 4.0, "radioactif": false, "vider_frigo": false},
			{"argent": 0.0, "honnetete": 2, "dette": 0, "fatigue": 0, "temps_verification": 4.0, "radioactif": false, "vider_frigo": false}
		]
	},
	6: {
		"question": "A coworker left his day's pay on the counter: [color=yellow]$30[/color]. He just went to the restroom.",
		"choix": [
			"Take cash quietly (+$30)",
			"Wait. Make a friend (-1 Fatigue tomorrow)"
		],
		"consequences": [
			{"argent": 30.0, "honnetete": -2, "dette": 0, "fatigue": 0, "temps_verification": 4.0, "radioactif": false, "vider_frigo": false},
			{"argent": 0.0, "honnetete": 1, "dette": 0, "fatigue": -1, "temps_verification": 4.0, "radioactif": false, "vider_frigo": false}
		]
	},
	7: {
		"question": "An elderly lady cannot afford her meal. She is short by [color=red]$15[/color].",
		"choix": [
			"Pay for her (-$15 | Slower rush tomorrow)",
			"Turn her away coldly"
		],
		"consequences": [
			{"argent": -15.0, "honnetete": 2, "dette": 0, "fatigue": 0, "temps_verification": 5.5, "radioactif": false, "vider_frigo": false},
			{"argent": 0.0, "honnetete": -1, "dette": 0, "fatigue": 0, "temps_verification": 4.0, "radioactif": false, "vider_frigo": false}
		]
	},
	8: {
		"question": "An anonymous hacker sends you a text: 'I can hack and reduce your debt in exchange for an illegal favor.'",
		"choix": [
			"Accept deal (-$10 Debt | Insane rush tomorrow)",
			"Ignore text"
		],
		"consequences": [
			{"argent": 0.0, "honnetete": -3, "dette": -10, "fatigue": 0, "temps_verification": 1.5, "radioactif": false, "vider_frigo": false},
			{"argent": 0.0, "honnetete": 1, "dette": 0, "fatigue": 0, "temps_verification": 4.0, "radioactif": false, "vider_frigo": false}
		]
	},
	9: {
		"question": "Henkins leaves the restaurant exhausted, forgetting his black briefcase full of money on a chair.",
		"choix": [
			"Steal briefcase (Clear debt! Max Corruption)",
			"Run after him to return it"
		],
		"consequences": [
			{"argent": 50.0, "honnetete": -5, "dette": 0, "fatigue": 0, "temps_verification": 4.0, "radioactif": false, "vider_frigo": false},
			{"argent": 0.0, "honnetete": 4, "dette": 0, "fatigue": 0, "temps_verification": 4.0, "radioactif": false, "vider_frigo": false}
		]
	},
	10: {
		"question": "It's your last day, right? Give this restaurant a bad reputation and I will pay you well.",
		"choix": [
			"Accept bribe (+$50)",
			"Report to the police"
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
	lb_question.text = donnees_evenement["question"]
	
	for enfant in hbox_reponses.get_children():
		enfant.queue_free()
		
	for i in range(donnees_evenement["choix"].size()):
		var texte_choix = donnees_evenement["choix"][i]
		
		var bouton = Button.new()
		bouton.text = texte_choix
		bouton.custom_minimum_size.y = 40
		bouton.pressed.connect(_on_choix_bouton_pressed.bind(i, texte_choix))
		
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
