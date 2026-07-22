extends Node

# Le tableau accepte maintenant notre ressource personnalisée
@export var playlist: Array[ElementMusique] = []
var musiques_historique: Array[ElementMusique] = []
var lecteur: AudioStreamPlayer

func _ready() -> void:
	if not lecteur:
		lecteur = AudioStreamPlayer.new()
		add_child(lecteur)
		
		# --- CHANGEMENT DE BUS ---
		# On assigne le lecteur au bus "Music" au lieu de "Master"
		lecteur.bus = "Music" 
		
		lecteur.finished.connect(_on_musique_terminee)
	
	if lecteur.playing:
		return
	
	if playlist.size() > 0:
		jouer_musique_aleatoire()

func jouer_musique_aleatoire() -> void:
	if musiques_historique.size() >= playlist.size():
		musiques_historique.clear()
		
	var choix_possibles = []
	for element in playlist:
		if not element in musiques_historique:
			choix_possibles.append(element)
			
	var element_choisi = choix_possibles.pick_random()
	musiques_historique.append(element_choisi)
	
	# --- APPLICATION DU TEXTURE ET DU VOLUME INDIVIDUEL ---
	lecteur.stream = element_choisi.fichier_audio
	lecteur.volume_db = element_choisi.volume_db # Le volume d'équilibrage du morceau
	
	lecteur.play()
	print("Playlist - Lecture : ", element_choisi.fichier_audio.resource_path.get_file(), " (Volume: ", element_choisi.volume_db, "dB)")

func _on_musique_terminee() -> void:
	await get_tree().create_timer(0.5).timeout
	jouer_musique_aleatoire()

# --- GESTION DU VOLUME GLOBAL DE LA MUSIQUE ---

## Règle le volume du bus "Music". Prend une valeur entre 0.0 (silence) et 1.0 (fond de balle).
func changer_volume_musique(valeur_lineaire: float) -> void:
	var bus_index = AudioServer.get_bus_index("Music")
	if bus_index != -1:
		# On convertit le slider (0 à 1) en décibels (dB) de manière fluide
		var volume_db = linear_to_db(valeur_lineaire)
		AudioServer.set_bus_volume_db(bus_index, volume_db)
		
		# Si la valeur est à 0, on coupe complètement le son (Mute)
		AudioServer.set_bus_mute(bus_index, valeur_lineaire <= 0.0)
