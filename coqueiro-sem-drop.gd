extends Sprite2D

@export var cena_coco: PackedScene  
@export var spawn_interval: float = 5.0

var timer: Timer

func _ready():
	timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.one_shot = true # 🔥 ESSENCIAL
	add_child(timer)
	timer.start()
