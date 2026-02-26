extends CharacterBody2D

@export var speed := 220.0
@export var jump_velocity := -420.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

# ===== สำหรับ One-Way Platform =====
var drop_timer := 0.0
@export var one_way_layer := 2   # Layer ของ One-Way Platform

func _ready() -> void:
	anim.play("idle")

func _physics_process(delta: float) -> void:
	# ----- แรงโน้มถ่วง -----
	if not is_on_floor():
		velocity.y += gravity * delta

	# ----- เดินซ้ายขวา -----
	var dir := Input.get_axis("ui_left", "ui_right")
	velocity.x = dir * speed

	# ----- กระโดด -----
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# ===== ร่วงทะลุ One-Way Platform =====
	# กด ลง + กระโดด
	if Input.is_action_just_pressed("ui_down") and Input.is_action_just_pressed("ui_accept"):
		# ปิดการชนกับ Layer ของ One-Way ชั่วคราว
		set_collision_mask_value(one_way_layer, false)
		drop_timer = 0.25   # เวลาไม่ชน (วินาที)

	# นับเวลาคืนการชน
	if drop_timer > 0.0:
		drop_timer -= delta
		if drop_timer <= 0.0:
			set_collision_mask_value(one_way_layer, true)

	move_and_slide()

	# ----- อนิเมชัน -----
	if dir != 0:
		anim.flip_h = dir < 0
		if anim.animation != "run":
			anim.play("run")
	else:
		if anim.animation != "idle":
			anim.play("idle")
