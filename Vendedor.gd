extends Node2D

@onready var balloon = $DialogueBalloon
@onready var label = $DialogueBalloon/DialogueLabel
@onready var collision = $CollisionShape2D
@export var text_speed := 0.02
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

@export var leave_distance := 64
@export var leave_speed := 80.0

var player_ref = null
var estoque := 3
var is_distracted := false
var is_broken := false
var leaving := false

var dialogues_normal := [
	"Picolé geladinho!",
	"Não posso sair daqui.",
	"Preciso vender tudo primeiro."
]

var dialogues_broken := [
	"O quê?!",
	"Meu isopor!",
	"Acabou tudo..."
]

var timer: Timer
var index := 0
var is_typing := false
var waiting := false

func _ready():
	add_to_group("npcs")

	timer = Timer.new()
	timer.wait_time = 0.1
	timer.timeout.connect(_type_char)
	add_child(timer)

	balloon.visible = false
	if anim:
		anim.play("idle")

func start_dialogue_with_player(player):
	player_ref = player
	player.talked_to_vendor = true

	# 🔥 QUEBRA DO ISOPOR
	if is_distracted and not is_broken and player.has_salt:
		_break_isopor()
		return

	start_dialogue()

func start_dialogue():
	if is_typing or leaving:
		return
	if waiting:
		_end()
		return

	balloon.visible = true

	if is_broken:
		label.text = dialogues_broken[index]
	else:
		label.text = dialogues_normal[index]

	label.visible_characters = 0
	is_typing = true
	timer.start()

func _type_char():
	label.visible_characters += 1
	if label.visible_characters >= label.get_total_character_count():
		timer.stop()
		is_typing = false
		waiting = true

func _end():
	waiting = false
	balloon.visible = false

	var size = dialogues_broken.size() if is_broken else dialogues_normal.size()
	index = (index + 1) % size

func _break_isopor():
	is_broken = true
	estoque = 0
	player_ref.has_salt = false
	
	if anim:
		anim.play("surprised")

	balloon.visible = true
	label.text = "Ei!! O que você fez?!"
	label.visible_characters = label.get_total_character_count()

	await get_tree().create_timer(1.5).timeout
	_leave_scene()

func _leave_scene():
	if leaving:
		return

	leaving = true
	
	if anim:
		#anim.play("run") 
		# Vira o sprite dependendo da direção que ele vai fugir
		if leave_distance < 0:
			anim.flip_h = true 
		else:
			anim.flip_h = false

	if collision:
		collision.disabled = true

	var target = global_position + Vector2(leave_distance, 0)

	while global_position.distance_to(target) > 2:
		global_position = global_position.move_toward(
			target,
			leave_speed * get_process_delta_time()
		)
		await get_tree().process_frame

	queue_free()
