extends Area2D

@export var teacher_id := "math"
@export var gate_path: NodePath
@export var quiz_ui_path: NodePath

@onready var anim: AnimatedSprite2D = $bat  # ✅ โหนดลูกชื่อ bat

var _can_talk := false

func _ready() -> void:
	# เล่นอนิเมชันยืน (loop)
	anim.play("default")

	body_entered.connect(_on_enter)
	body_exited.connect(_on_exit)

func _process(_delta: float) -> void:
	if _can_talk and Input.is_action_just_pressed("ui_accept"):
		var quiz_ui = get_node(quiz_ui_path)
		quiz_ui.start_quiz(teacher_id, get_node(gate_path))

		# ถ้าอยากให้มันเล่นซ้ำตอนเริ่มคุย (optional)
		anim.stop()
		anim.play("default")

		_can_talk = false

func _on_enter(body: Node) -> void:
	if body is CharacterBody2D:
		_can_talk = true

func _on_exit(body: Node) -> void:
	if body is CharacterBody2D:
		_can_talk = false
