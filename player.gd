extends CharacterBody2D
@onready var anim: AnimatedSprite2D = $Sprite2D

var movimento : float = 150.0
var gravidade : float = 850.0
var pulo : float = 380.0
var cocos_count: int = 0 

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
	if Input.is_action_just_pressed("collect"):
		try_collect_coco()
	if Input.is_action_just_pressed("talk"):  
		try_talk_to_npc()
	
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
# Função que tenta coletar o coco mais próximo
func try_collect_coco() -> void:
	var cocos = get_tree().get_nodes_in_group("cocos")
	for coco in cocos:
		if global_position.distance_to(coco.global_position) < 300:
			coco.collect(self)


func add_coco():
	cocos_count += 1
	print("Coco coletado! Total agora: ", cocos_count)

func try_talk_to_npc():
	var npcs = get_tree().get_nodes_in_group("npcs")
	var talked := false
	
	for npc in npcs:
		if global_position.distance_to(npc.global_position) < 200:
			npc.start_dialogue()
			talked = true
			break
	
	# Se apertou E mas não tem NPC perto → fecha diálogos
	if not talked:
		for npc in npcs:
			npc.force_close_dialogue()
