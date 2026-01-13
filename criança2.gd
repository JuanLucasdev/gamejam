extends Node2D

@onready var balloon = $DialogueBalloon
@onready var label = $DialogueBalloon/DialogueLabel
@onready var collision = $CollisionShape2D

var player_ref = null
var boneco_entregue := false
var reward_given := false

var dialogues_before := [
	"Eu perdi meu boneco…",
	"Acho que ele caiu perto das pedras.",
	"Sem ele eu não consigo ir embora."
]

var dialogues_after := [
	"Você achou!",
	"Era muito importante pra mim.",
	"Toma isso, achei na mochila."
]

var dialogue_index := 0
var timer: Timer
var is_typing := false
var waiting := false

func _ready():
	add_to_group("npcs")
	if collision:
		collision.disabled = true
	
	timer = Timer.new()
	timer.wait_time = 0.1
	timer.timeout.connect(_type_char)
	add_child(timer)
	
	balloon.visible = false

func start_dialogue_with_player(player):
	player_ref = player
	if player_ref.has_doll:   
		boneco_entregue = true
	start_dialogue()

func start_dialogue():
	if is_typing:
		return
	if waiting:
		_next()
		return
	_show()

func _show():
	var texts = dialogues_after if boneco_entregue else dialogues_before
	
	if dialogue_index >= texts.size():
		_end()
		return
	
	balloon.visible = true
	label.text = texts[dialogue_index]
	label.visible_characters = 0
	
	is_typing = true
	waiting = false
	timer.start()

func _type_char():
	label.visible_characters += 1
	if label.visible_characters >= label.get_total_character_count():
		timer.stop()
		is_typing = false
		waiting = true

func _next():
	waiting = false
	dialogue_index += 1
	_show()

func _end():
	balloon.visible = false
	dialogue_index = 0
	

	if boneco_entregue and not reward_given and player_ref:
		
		player_ref.has_salt = true
		print("Player recebeu o Sal!")
		
		player_ref.has_doll = false 
		
		reward_given = true

func force_close_dialogue():
	timer.stop()
	balloon.visible = false
	is_typing = false
	waiting = false
