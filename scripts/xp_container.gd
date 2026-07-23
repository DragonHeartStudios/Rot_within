extends HBoxContainer

@onready var xp: Label = %xp
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var texture_rect: TextureRect = $image/TextureRect

@export var animation_duration: float = 0.8
@export var custom_curve: Curve

@export_group("Réglages Son & Effet")
@export var min_sound_interval: float = 0.15 
@export var thump_scale_factor: float = 1.15
@export var thump_pulse_time: float = 0.02
@export var thump_decay_time: float = 0.15

var current_xp: int = 0
var start_xp: int = 0
var target_xp: int = 0
var last_sound_time: float = 0.0
var tween: Tween
var tween_thump: Tween

func _ready() -> void:
	current_xp = GameManager.xp
	target_xp = GameManager.xp 
	xp.text = str(current_xp)

func _process(_delta: float) -> void:
	if target_xp != GameManager.xp:
		_animate_xp(GameManager.xp)

func _animate_xp(new_target: int) -> void:
	if tween:
		tween.kill()
		
	start_xp = current_xp
	target_xp = new_target
	
	tween = create_tween()
	tween.tween_method(_update_xp_step, 0.0, 1.0, animation_duration)

func _update_xp_step(progress: float) -> void:
	var weight = custom_curve.sample(progress) if custom_curve else progress
	var calculated_xp = int(lerp(float(start_xp), float(target_xp), weight))
	
	if calculated_xp != current_xp:
		current_xp = calculated_xp
		xp.text = str(current_xp)
		
		var now = Time.get_ticks_msec() / 1000.0
		if now - last_sound_time >= min_sound_interval:
			last_sound_time = now
			
			if audio_stream_player:
				audio_stream_player.play()
			
			_jouer_effet_thump()

func _jouer_effet_thump() -> void:
	if tween_thump:
		tween_thump.kill()
	
	tween_thump = create_tween()
	
	var target_scale = Vector2(thump_scale_factor, thump_scale_factor)
	
	# Uniquement le scale
	tween_thump.tween_property(texture_rect, "scale", target_scale, thump_pulse_time)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
		
	tween_thump.tween_property(texture_rect, "scale", Vector2.ONE, thump_decay_time)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
