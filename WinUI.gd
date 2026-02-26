extends Control

@export var main_menu_path := "res://MainMenu.tscn"
@onready var back_btn: Button = $Panel/CenterContainer/VBoxContainer/BackButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	back_btn.process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	mouse_filter = Control.MOUSE_FILTER_STOP
	back_btn.mouse_filter = Control.MOUSE_FILTER_STOP
	back_btn.disabled = false

	if not back_btn.pressed.is_connected(_on_back_pressed):
		back_btn.pressed.connect(_on_back_pressed)

func show_win() -> void:
	visible = true
	get_tree().paused = true

func _on_back_pressed() -> void:
	print("BACK PRESSED")  # ✅ ต้องเห็นใน Output
	get_tree().paused = false
	get_tree().call_deferred("change_scene_to_file", main_menu_path)
