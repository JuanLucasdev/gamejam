extends Control

@export var tempo_na_tela : float = 3.0    

@onready var timer : Timer = $Timer
@onready var label : Label = $Label


func _ready() -> void:
	

	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment   = VERTICAL_ALIGNMENT_CENTER
	
	timer.wait_time = tempo_na_tela
	timer.one_shot  = true
	
	if not timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
	
	timer.start()


func _on_timer_timeout() -> void:
	var quit = get_tree().change_scene_to_file("res://titlescreen.tscn")
