extends Node

signal argent_update
signal energy_update
signal day_update

var day : int = 1:
	set(nouvelle_valeur):
		day = nouvelle_valeur # 1. On applique le changement de valeur
		day_update.emit()               # 2. On appelle ta fonction !

var energy : int = 100: # l'energie qu'on a le premier jour
	set(nouvelle_valeur):
		energy = nouvelle_valeur # 1. On applique le changement de valeur
		energy_update.emit()               # 2. On appelle ta fonction !

var max_energy : int = 100

var argent : float = 25.50: #l'agrent qu'on a le premier jour
	set(nouvelle_valeur):
		argent = nouvelle_valeur # 1. On applique le changement de valeur
		argent_update.emit()               # 2. On appelle ta fonction !

var xp : int = 0 # point d'experience du joueur
# --- VARIABLES DE FACTURE ---
var salair_brute := 0.0
var prix_des_ingredient := 0.0
var client_pas_content := 0

var dette := 500 #le montant de la dette

var honnetete := -10

var echeance := 10 #le nombre de jours qu'on a pour payer notre dette

var ending := ""

var slots_du_frigo : Dictionary = {}

var ingr_radioactive := false #false par default

var fatigue := 10 #le nombre de point d'énergie que tu pere quand tu vend une command

var temps_verification: float = 12.0# Temps (en secondes) entre chaque vérification pour ajouter un nouveaux client. en gros la vitesse d'apparision des client

var first_day := true

var first_service := true

var first_night := true

var hight_score_mutant := 0.0

var order_speed : float = 10

var speed_customers : float = 5

var tips := 0

# --- VARIABLES DE MUTATION ---
var ratio_monstres_demain : float = 0.0
var plats_radioactifs_aujourd_hui : int = 0

func _ready() -> void:
	argent_update.emit()
	energy_update.emit()
	day_update.emit()

func _process(_delta: float) -> void:
	if energy < 0:
		energy = 0
		
	if dette < 0:
		dette = 0

# --- FONCTION DE FIN DE JOURNÉE ---
func preparer_journee_suivante() -> void:
	# Calcule le ratio (Base 10 : 1 plat = 10% de chance, max 100%)
	ratio_monstres_demain = clamp(float(plats_radioactifs_aujourd_hui) / 10.0, 0.0, 1.0)
	if plats_radioactifs_aujourd_hui > hight_score_mutant:
		hight_score_mutant = plats_radioactifs_aujourd_hui
	# Réinitialise le compteur pour le jour qui commence
	plats_radioactifs_aujourd_hui = 0
	print("Taux de monstres calculé pour le lendemain : ", ratio_monstres_demain * 100, "%")
