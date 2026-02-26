extends Area2D

@export var boost := -750.0
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	anim.play("default") # เล่นรอไว้เบาๆ

	body_entered.connect(func(body):
		if body is CharacterBody2D:
			# เด้งตัวผู้เล่น
			body.velocity.y = boost
			
			# เล่นอนิเมชันฟองน้ำ
			anim.stop()
			anim.play("default")
	)
