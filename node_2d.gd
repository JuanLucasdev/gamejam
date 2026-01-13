extends Node2D
@onready var music: AudioStreamPlayer = $thema

var exposicao := 0.0
var esta_na_sombra := false

const MAX := 100.0
const TAXA_SOL := 5.0
const TAXA_SOMBRA := 10.0

@onready var hud = $HUD 

# Variável para guardar a referência do Player
var player_ref = null 

func _on_sombra_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body.is_in_group("player"):
		esta_na_sombra = true

func _on_sombra_body_exited(body: Node2D) -> void:
	if body.name == "Player" or body.is_in_group("player"):
		esta_na_sombra = false
		
func _process(delta: float) -> void:
	# Lógica do Sol
	if esta_na_sombra:
		exposicao -= TAXA_SOMBRA * delta
	else:
		exposicao += TAXA_SOL * delta

	exposicao = clamp(exposicao, 0, MAX)

	# --- ATUALIZAÇÃO DA HUD ---
	
	# 1. Tenta encontrar o Player na cena se ainda não encontrou
	if player_ref == null:
		# Busca o primeiro nó que esteja no grupo "player"
		player_ref = get_tree().get_first_node_in_group("player")
	
	# 2. Se achou o Player e a HUD existe, atualiza tudo
	if player_ref and hud:
		hud.atualizar_hud(player_ref, exposicao, MAX)
		
	# Dano
	if exposicao >= MAX:
		print("O Player está queimando!")
func _ready() -> void:
	if music:
		music.volume_db = -80.0   
		music.play()            
		
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_SINE)
		tween.tween_property(music, "volume_db", -12.0, 2.0)
	
