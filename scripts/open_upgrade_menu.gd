extends Button

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_pressed() -> void:
	%upgrade.visible = true
	audio_stream_player.play()
	animation_player.play("open_shop")
