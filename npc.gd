extends Node2D

@onready var balloon: Control = $DialogueBalloon
@onready var label: RichTextLabel = $DialogueBalloon/DialogueLabel
@onready var collision: CollisionShape2D = $CollisionShape2D

var current_dialogue_index: int = 0

var dialogues: Array[String] = [
	"Olá, aventureiro! Pegue os cocos!",
	"Essa praia é perigosa, cuidado!",
	"A bandeira leva pra próxima fase!",
	"Colete 1 coco pra ganhar força!"
]

@export var dialogue_speed: float = 0.1

var timer: Timer
var is_typing := false
var waiting_input := false
var dialogue_active := false

func _ready():
	add_to_group("npcs")
	
	label.bbcode_enabled = true
	label.visible_characters = 0
	
	timer = Timer.new()
	timer.wait_time = dialogue_speed
	timer.timeout.connect(_type_next_char)
	add_child(timer)
	
	balloon.visible = false

func start_dialogue():
	if collision and collision.disabled:
		return
	
	if is_typing:
		return
	
	if waiting_input:
		_next_dialogue()
		return
	
	_show_current_dialogue()

func _show_current_dialogue():
	if current_dialogue_index >= dialogues.size():
		_end_all_dialogues()
		return
	
	dialogue_active = true
	balloon.visible = true
	
	label.bbcode_text = dialogues[current_dialogue_index]
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
	current_dialogue_index += 1
	_show_current_dialogue()

func _end_all_dialogues():
	dialogue_active = false
	balloon.visible = false
	
	if collision:
		collision.disabled = true

func force_close_dialogue():
	if dialogue_active:
		timer.stop()
		is_typing = false
		waiting_input = false
		dialogue_active = false
		balloon.visible = false
