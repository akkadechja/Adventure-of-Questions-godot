extends Area2D

@export var win_ui_path: NodePath
@onready var coin_anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	coin_anim.play("default") # ✅ ให้เหรียญเล่นตลอด
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		get_node(win_ui_path).show_win()
