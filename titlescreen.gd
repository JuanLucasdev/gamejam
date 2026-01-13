extends Control

@onready var music: AudioStreamPlayer = $titlemusic  

func _ready() -> void:

	music.volume_db = -80.0          
	music.play(53.0)                 
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(music, "volume_db", -12.0, 2.0)
	
func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://fase2.tscn")

func _on_credits_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://credits.tscn")

func _on_quit_btn_pressed() -> void:
	get_tree().quit()
