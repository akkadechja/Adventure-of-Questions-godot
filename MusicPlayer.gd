extends Node

@onready var bgm: AudioStreamPlayer = $BGM

func play_music() -> void:
	if not bgm.playing:
		bgm.play()

func stop_music() -> void:
	if bgm.playing:
		bgm.stop()
