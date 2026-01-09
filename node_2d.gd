extends Node2D

var exposicao := 0.0
var esta_na_sombra := false

const MAX := 100.0
const TAXA_SOL := 10.0
const TAXA_SOMBRA := 10.0

func _on_sombra_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		esta_na_sombra = true

func _on_sombra_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		esta_na_sombra = false
		
func _process(delta: float) -> void:
	if esta_na_sombra:
		exposicao -= TAXA_SOMBRA * delta
	else:
		exposicao += TAXA_SOL * delta

	exposicao = clamp(exposicao, 0, MAX)

	$UI/Label.text = str(int(exposicao)) + "%"
