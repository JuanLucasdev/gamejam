extends CharacterBody2D

@export var speed: float = 80.0
@export var distancia: float = 200.0

@onready var inicio: Vector2 = global_position
var target: Vector2
var indo: bool = true

func _ready():
	target = inicio + Vector2(distancia, 0)

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

	$AnimatedSprite2D.flip_h = velocity.x > 0
