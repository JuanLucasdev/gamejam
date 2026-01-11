extends Node2D

@onready var balloon: Control = $DialogueBalloon
@onready var label: RichTextLabel = $DialogueBalloon/DialogueLabel
@onready var collision: CollisionShape2D = $CollisionShape2D

var current_dialogue_index := 0
var trade_done := false

var dialogues_before_trade := [
	"Nossa… eu queria uma água de coco.",
	"Moço, o senhor pode me ajudar?",
	"Se você tiver um coco, eu posso trocar com você."
]

var dialogues_after_trade := [
	"Obrigado!",
	"Toma, esse apito era do meu pai.",
	"Talvez ele te ajude por aí."
]

@export var dialogue_speed := 0.1

var timer: Timer
var is_typing := false
var waiting_input := false
var dialogue_active := false
var player_ref: Node = null

func _ready():
	add_to_group("npcs")
	
	if collision:
		collision.disabled = true
	
	label.bbcode_enabled = true
	label.visible_characters = 0
	
	timer = Timer.new()
	timer.wait_time = dialogue_speed
	timer.timeout.connect(_type_next_char)
	add_child(timer)
	
	balloon.visible = false

# 🔥 Só a criança tem isso
func start_dialogue_with_player(player: Node):
	player_ref = player
	start_dialogue()

func start_dialogue():
	if is_typing:
		return
	
	if waiting_input:
		_next_dialogue()
		return
	
	_show_current_dialogue()

func _show_current_dialogue():
	dialogue_active = true
	balloon.visible = true
	
	var active_dialogues = dialogues_after_trade if trade_done else dialogues_before_trade
	
	if current_dialogue_index >= active_dialogues.size():
		_end_dialogue()
		return
	
	label.bbcode_text = active_dialogues[current_dialogue_index]
	label.visible_characters = 0
	
	is_typing = true
	waiting_input = false
	timer.start()

func _type_next_char():
	label.visible_characters += 1
	
	if label.visible_characters >= label.get_total_character_count():
		timer.stop()
		is_typing = false
		waiting_input = true

func _next_dialogue():
	waiting_input = false
	
	if not trade_done \
	and current_dialogue_index == dialogues_before_trade.size() - 1 \
	and player_ref \
	and player_ref.cocos_count > 0:
		
		player_ref.remove_coco()
		player_ref.receive_whistle()
		trade_done = true
		current_dialogue_index = 0
		return
	
	current_dialogue_index += 1
	_show_current_dialogue()

func _end_dialogue():
	dialogue_active = false
	balloon.visible = false
	current_dialogue_index = 0

func force_close_dialogue():
	if dialogue_active:
		timer.stop()
		is_typing = false
		waiting_input = false
		dialogue_active = false
		balloon.visible = false
