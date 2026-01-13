extends AudioStreamPlayer

@onready var music: AudioStreamPlayer = $CreditsMusic

func _ready() -> void:
	# ... seu código anterior de label, timer, etc.
	
	if music:
		music.volume_db = -80  # começa baixo para fade in
		music.play(68.0)       # ← começa exatamente em 45 segundos (1:25)
		
		# Fade in opcional
		var tween = create_tween()
		tween.tween_property(music, "volume_db", -12, 2.0)  # sobe para -12dB em 2s
