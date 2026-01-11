extends Area2D

@export var next_scene_path: String = "res://fase2.tscn"  # Arraste a próxima cena aqui!

func _ready():
	# Conecta o sinal automaticamente
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	print("Entrou na bandeira: ", body.name)  # Testa se sinal dispara
	print("Groups do body: ", body.get_groups()) 
	if body.is_in_group("Player"):
		print("Player detectado! Mudando cena...")
		get_tree().change_scene_to_file(next_scene_path)
