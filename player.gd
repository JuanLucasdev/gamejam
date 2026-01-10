extends CharacterBody2D
@onready var anim: AnimatedSprite2D = $Sprite2D

var movimento : float = 150.0
var gravidade : float = 850.0
var pulo : float = 380.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravidade*delta
	velocity.x = 0
	
	var direction := Input.get_axis("left", "right")
	
	if Input.is_action_pressed("right"):
		velocity.x += movimento
	if Input.is_action_pressed("left"):
		velocity.x -= movimento
	if Input.is_action_just_pressed("up"):
		velocity.y = -pulo
	
	if is_on_floor():
		if direction >0:
			anim.flip_h = false
			anim.play("walk")
		elif direction <0:
			anim.flip_h = true	
			anim.play("walk")
		else:
			anim.play("idle")
	else:
		if direction >0:
			anim.flip_h = false
			anim.play("jump")
		else:
			anim.flip_h = true	
			anim.play("jump")
			
	
	move_and_slide()
