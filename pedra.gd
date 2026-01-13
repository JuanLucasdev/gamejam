extends Node2D

const SPEED: int = 300

func _process(delta: float) -> void:
	position += transform.x * SPEED * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

# --- NOVA FUNÇÃO ---
# Essa função roda quando o Area2D da pedra encosta em outro corpo (chão, caranguejo, etc)
func _on_area_2d_body_entered(body: Node2D) -> void:
	# 1. SE FOR O PLAYER, NÃO FAZ NADA (deixa a pedra passar)
	# Verifica pelo grupo "player" ou pelo nome do objeto
	if body.is_in_group("player") or body.name == "Player":
		return 

	# 2. SE FOR INIMIGO (tem o método tomar_dano)
	if body.has_method("tomar_dano"):
		body.tomar_dano()
		queue_free() # Pedra some ao acertar inimigo
		
	# 3. SE FOR PAREDE/CHÃO (não é player, nem inimigo)
	else:
		queue_free() # Pedra some ao bater na parede
