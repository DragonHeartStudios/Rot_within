extends Resource
class_name ElementMusique

@export var fichier_audio: AudioStream
# Volume en décibels (0 = volume normal, -10 = plus bas, +5 = plus fort)
@export_range(-40.0, 10.0, 0.1) var volume_db: float = 0.0
