extends CharacterBody2D

@export var speed: float = 80.0
@export var distancia: float = 200.0
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var inicio: Vector2 = global_position
var target: Vector2
var indo: bool = true
var tem_boneco: bool = true

const BONECO_CENA = preload("res://boneco_drop.tscn")

func _ready():
	target = inicio + Vector2(distancia, 0)
	anim.play("hold")
func _physics_process(delta):
	var dir: float = sign(target.x - global_position.x)

	velocity.x = dir * speed
	move_and_slide()

	if abs(global_position.x - target.x) < 2.0:
		if indo:
			target = inicio
		else:
			target = inicio + Vector2(distancia, 0)
		indo = !indo

	anim.flip_h = velocity.x > 0
	
var vida := 1
	
func tomar_dano():
	if tem_boneco:
		call_deferred("soltar_boneco")

func soltar_boneco():
	tem_boneco = false # Marca que perdeu o item
	
	# 1. Cria o boneco no mundo
	var boneco = BONECO_CENA.instantiate()
	get_parent().add_child(boneco)
	boneco.global_position = global_position
	
	# 2. Muda a animação do caranguejo para "andar sem nada"
	# Certifique-se de ter uma animação chamada "walk" (ou o nome que você deu)
	anim.play("idle") 
	
	# [OPCIONAL] Faz ele correr mais rápido de susto!
	speed = 150.0 
	
	print("Caranguejo derrubou o boneco e saiu correndo!")
	
	# NOTA: Não usamos queue_free(), então ele continua vivo.
	
