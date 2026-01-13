extends Node2D

const PEDRA = preload("res://pedra.tscn")

# Tempo em segundos entre cada tiro
var tempo_recarga: float = 0.8
var pode_atirar: bool = true

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	# Agora verificamos se apertou O BOTÃO e se PODE ATIRAR
	if Input.is_action_just_pressed("fire") and pode_atirar:
		atirar()

func atirar() -> void:
	pode_atirar = false # Bloqueia novos tiros imediatamente
	
	var pedra_i = PEDRA.instantiate()
	get_tree().root.add_child(pedra_i)
	pedra_i.global_position = global_position
	pedra_i.rotation = rotation
	
	if get_parent().has_method("play_shoot_animation"):
		get_parent().play_shoot_animation()
		
	# Espera o tempo da recarga e depois libera o tiro
	await get_tree().create_timer(tempo_recarga).timeout
	pode_atirar = true
