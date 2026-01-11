extends Node2D

@onready var balloon = $DialogueBalloon
@onready var label = $DialogueBalloon/DialogueLabel
@onready var collision = $CollisionShape2D

@export var vendedor_path: NodePath
@export var move_distance := 32
@export var move_speed := 80.0
@export var wait_time := 2.0

var vendedor: Node = null
var original_position: Vector2
var busy := false
var exiting := false

var player_ref = null
var timer: Timer
var is_typing := false
var waiting := false
var dialogue_index := 0

var dialogues_idle := [
	"Tá quente demais hoje...",
	"Só queria me refrescar."
]

var dialogues_request := [
	"Picolé?",
	"Ah… por que não?"
]

func _ready():
	collision.disabled = true
	add_to_group("npcs")

	if vendedor_path != NodePath():
		vendedor = get_node_or_null(vendedor_path)
	else:
		vendedor = null

	original_position = global_position

	timer = Timer.new()
	timer.wait_time = 0.1
	timer.timeout.connect(_type_char)
	add_child(timer)

	balloon.visible = false

func _exit_tree():
	exiting = true
	vendedor = null

# ======================
# DIALOGUE
# ======================

func start_dialogue_with_player(player):
	player_ref = player
	start_dialogue()

func start_dialogue():
	if exiting or busy:
		return
	if is_typing:
		return
	if waiting:
		_next()
		return

	dialogue_index = 0
	_show()

func _show():
	var texts

	if player_ref and player_ref.talked_to_vendor:
		texts = dialogues_request
	else:
		texts = dialogues_idle

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

	# inicia distração se possível
	if _can_distract():
		_start_distraction()

func force_close_dialogue():
	timer.stop()
	balloon.visible = false
	is_typing = false
	waiting = false

# ======================
# DISTRACTION LOGIC
# ======================

func _can_distract() -> bool:
	return (
		not busy
		and player_ref != null
		and player_ref.talked_to_vendor
		and _has_vendedor()
	)

func _has_vendedor() -> bool:
	return vendedor != null and is_instance_valid(vendedor)

func _start_distraction():
	if not _has_vendedor():
		return

	busy = true
	vendedor.is_distracted = true

	await _move_to(vendedor.global_position + Vector2(-16, 0))
	await get_tree().create_timer(wait_time).timeout

	if _has_vendedor():
		vendedor.is_distracted = false

	await _move_to(original_position)
	busy = false

func _move_to(target: Vector2) -> void:
	while (
		not exiting
		and is_inside_tree()
		and global_position.distance_to(target) > 2
	):
		global_position = global_position.move_toward(
			target,
			move_speed * get_process_delta_time()
		)
		await get_tree().process_frame
