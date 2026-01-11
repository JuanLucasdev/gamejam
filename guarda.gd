extends Node2D

@onready var balloon: Control = $DialogueBalloon
@onready var label: RichTextLabel = $DialogueBalloon/DialogueLabel
@onready var collision: CollisionShape2D = $CollisionShape2D

var current_dialogue_index := 0
var player_ref: Node = null
var guard_leaving := false

var dialogues_blocking := [
	"Ei! Você não pode passar por aqui.",
	"Sem protetor solar, a praia é perigosa.",
	"Agora saia daqui…",
	"Preciso ficar atento ao apito, caso alguém se afogue."
]

var dialogues_allow := [
	"O quê?",
	"Esse apito…",
	"Se alguém se afogar, preciso estar atento!",
	"Pode passar, eu assumo daqui."
]

@export var dialogue_speed := 0.1

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

func start_dialogue_with_player(player: Node):
	player_ref = player
	start_dialogue()

func start_dialogue():
	if guard_leaving:
		return
	
	if is_typing:
		return
	
	if waiting_input:
		_next_dialogue()
		return
	
	_show_current_dialogue()

func _show_current_dialogue():
	dialogue_active = true
	balloon.visible = true
	
	var active_dialogues = dialogues_allow if _player_has_whistle() else dialogues_blocking
	
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
	current_dialogue_index += 1
	_show_current_dialogue()

func _end_dialogue():
	dialogue_active = false
	balloon.visible = false
	
	if _player_has_whistle():
		_guard_leave()
	
	current_dialogue_index = 0

func _player_has_whistle() -> bool:
	return player_ref and player_ref.has_whistle

func _guard_leave():
	if guard_leaving:
		return
	
	guard_leaving = true
	
	if collision:
		collision.disabled = true
	
	var tween = create_tween()
	tween.tween_property(self, "position:x", position.x - 80, 1.2)
	tween.tween_callback(queue_free)

func force_close_dialogue():
	if dialogue_active:
		timer.stop()
		is_typing = false
		waiting_input = false
		dialogue_active = false
		balloon.visible = false
