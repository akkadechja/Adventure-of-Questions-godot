extends Control

@export var level_scene_path: String = "res://Level.tscn"

@onready var settings_panel: Panel = %SettingsPanel
@onready var fullscreen_check: CheckBox = %FullscreenCheck
@onready var music_slider: HSlider = %MusicSlider
@onready var music_value: Label = %MusicValueLabel
@onready var sfx_slider: HSlider = %SfxSlider
@onready var sfx_value: Label = %SfxValueLabel

@onready var start_btn: Button = %StartButton
@onready var settings_btn: Button = %SettingsButton
@onready var quit_btn: Button = %QuitButton
@onready var back_btn: Button = %BackButton

func _ready() -> void:
	# ✅ ให้เพลงเล่นตั้งแต่เมนู และเล่นต่อในด่าน (Autoload)
	MusicPlayer.play_music()

	start_btn.pressed.connect(_on_start)
	settings_btn.pressed.connect(_on_open_settings)
	quit_btn.pressed.connect(_on_quit)
	back_btn.pressed.connect(_on_close_settings)

	music_slider.value_changed.connect(_on_music_changed)
	sfx_slider.value_changed.connect(_on_sfx_changed)
	fullscreen_check.toggled.connect(_on_fullscreen_toggled)

	settings_panel.visible = false
	music_slider.value = 80
	sfx_slider.value = 80
	_update_value_labels()

func _on_start() -> void:
	get_tree().change_scene_to_file(level_scene_path)

func _on_open_settings() -> void:
	settings_panel.visible = true

func _on_close_settings() -> void:
	settings_panel.visible = false

func _on_quit() -> void:
	get_tree().quit()

func _on_fullscreen_toggled(on: bool) -> void:
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_FULLSCREEN if on else DisplayServer.WINDOW_MODE_WINDOWED
	)

func _on_music_changed(v: float) -> void:
	_set_bus_volume("Music", v)
	_update_value_labels()

func _on_sfx_changed(v: float) -> void:
	_set_bus_volume("SFX", v)
	_update_value_labels()

func _set_bus_volume(bus_name: String, percent: float) -> void:
	var bus_idx := AudioServer.get_bus_index(bus_name)
	if bus_idx < 0:
		return
	var db := linear_to_db(clamp(percent / 100.0, 0.0, 1.0))
	AudioServer.set_bus_volume_db(bus_idx, db)
	AudioServer.set_bus_mute(bus_idx, percent <= 0.0)

func _update_value_labels() -> void:
	music_value.text = "Music: %d" % int(music_slider.value)
	sfx_value.text = "SFX: %d" % int(sfx_slider.value)
