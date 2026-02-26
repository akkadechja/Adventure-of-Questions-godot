extends StaticBody2D

func unlock() -> void:
	visible = false
	for c in get_children():
		if c is CollisionShape2D:
			c.disabled = true
