extends CharacterBody2D

var movimento : float = 250.0
var gravidade : float = 850.0
var pulo : float = 450.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravidade*delta
	velocity.x = 0
	if Input.is_action_pressed("right"):
		velocity.x += movimento
	if Input.is_action_pressed("left"):
		velocity.x -= movimento
	if Input.is_action_just_pressed("up"):
		velocity.y = -pulo
	move_and_slide()
