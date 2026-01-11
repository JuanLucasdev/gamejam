extends Sprite2D

@export var cena_coco: PackedScene  
@export var spawn_interval: float = 5.0

var timer: Timer

func _ready():
	timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.one_shot = true # 🔥 ESSENCIAL
	timer.timeout.connect(_spawn_coco)
	add_child(timer)
	timer.start()

func _spawn_coco():
	var coco = cena_coco.instantiate()
	
	var spawn_pos = $"area do coco".global_position
	coco.global_position = spawn_pos

	get_tree().current_scene.add_child(coco)
