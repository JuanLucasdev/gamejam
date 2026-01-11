extends RigidBody2D

signal collected(player)  # Sinal opcional pra efeitos extras

func _ready():
	gravity_scale = 2.0  # Cai mais rápido (ajuste se quiser)
	linear_damp = 0.5  # Para devagar no chão (rola levemente natural)
	
	# Adiciona ao group pra player achar
	add_to_group("cocos")


func collect(player: CharacterBody2D):
	player.add_coco()
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3)  # Fade transparente
	tween.tween_callback(queue_free)  # Deleta após 0.3s
	
	# Opcional: som/partículas aqui
	collected.emit(player)
