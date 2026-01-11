extends ParallaxLayer

@export var CLOUD_SPEED: float = -15.0

func _process(delta: float) -> void:
	motion_offset.x +=CLOUD_SPEED * delta
