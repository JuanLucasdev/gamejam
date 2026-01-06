extends CharacterBody2D

var movimento : float = 100.0
var tolerancia := 3.0 

func _physics_process(delta: float) -> void:
	var posicao = %Player.global_position.x
	var distancia = posicao - global_position.x
	if global_position.x < posicao:
		velocity.x += movimento * delta
	if global_position.x > posicao:
		velocity.x -= movimento * delta
	if abs(distancia) < tolerancia:
		velocity.x = 0 
	move_and_slide()
