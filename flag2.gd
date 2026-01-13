extends Area2D

@export var next_scene_path: String = "res://credits.tscn"

func _ready() -> void:

	
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("player"): 
		call_deferred("_change_scene")

func _change_scene() -> void:
	var error = get_tree().change_scene_to_file(next_scene_path)
