extends Area2D

@export var spawn_point_path: NodePath

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		var spawn: Marker2D = get_node(spawn_point_path)
		body.global_position = spawn.global_position
		body.velocity = Vector2.ZERO
