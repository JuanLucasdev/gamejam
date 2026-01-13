extends CharacterBody2D
@onready var anim: AnimatedSprite2D = $Sprite2D

var movimento : float = 150.0
var gravidade : float = 850.0
var pulo : float = 380.0
var cocos_count: int = 0 
var has_whistle := false
var has_salt := false
var has_doll := false
var talked_to_vendor := false
var is_shooting := false
var has_slingshot := true

func _ready() -> void:
	add_to_group("player")
	# Conecta o sinal que avisa quando uma animação termina
	anim.animation_finished.connect(_on_animation_finished)


func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += gravidade*delta
	velocity.x = 0
	
	var direction := Input.get_axis("left", "right")
	
	if Input.is_action_pressed("right"):
		velocity.x += movimento
	if Input.is_action_pressed("left"):
		velocity.x -= movimento
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = -pulo
	if Input.is_action_just_pressed("collect"):
		try_collect_coco()
	if Input.is_action_just_pressed("talk"):  
		try_talk_to_npc()
		
	if not is_shooting:
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
	
func play_shoot_animation():
	is_shooting = true
	anim.play("shoot") 
	if get_global_mouse_position().x < global_position.x:
		anim.flip_h = true
	else:
		anim.flip_h = false
func _on_animation_finished():
	if anim.animation == "shoot":
		is_shooting = false
func try_collect_coco() -> void:
	var cocos = get_tree().get_nodes_in_group("cocos")
	for coco in cocos:
		if global_position.distance_to(coco.global_position) < 300:
			coco.collect(self)


func add_coco():
	cocos_count += 1

func try_talk_to_npc():
	var npcs = get_tree().get_nodes_in_group("npcs")
	var talked := false
	
	for npc in npcs:
		if global_position.distance_to(npc.global_position) < 200:
			
			if npc.has_method("start_dialogue_with_player"):
				npc.start_dialogue_with_player(self)
			else:
				npc.start_dialogue()
			
			talked = true
			break
	
	if not talked:
		for npc in npcs:
			if npc.has_method("force_close_dialogue"):
				npc.force_close_dialogue()


func remove_coco():
	cocos_count -= 1
	print("Coco entregue. Restam: ", cocos_count)

func receive_whistle():
	has_whistle = true
	print("Apito recebido!")
	
func receive_doll():
	has_doll = true
	print("Boneco recebido!")
	



	
