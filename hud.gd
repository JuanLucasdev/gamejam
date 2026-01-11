extends CanvasLayer

@onready var label: Label = $Control/HBoxContainer/CocoCollectedLabel

func _ready():
	if label == null:
		push_error("ERRO: Label não encontrado! Verifique o caminho $Control/HBoxContainer/CocoCollectedLabel")
		return
	label.visible = false  # Começa escondido

# Chama isso quando coletar o coco
func show_coco_collected():
	if label == null:
		print("Label null - não consigo mostrar mensagem!")
		return
	
	label.visible = true
	label.text = "Coco coletado!"
	
	# Opcional: some depois de 3 segundos
	await get_tree().create_timer(3.0).timeout
	label.visible
