extends CanvasLayer

# --- REFERÊNCIAS VISUAIS ---
# O $TextureProgressBar pega o nó filho direto (como estava no seu código original)
@onready var termometro = $TextureProgressBar 

# Aqui usamos o % (Unique Name) exatamente como está na sua imagem
@onready var icon_estilingue = %IconeEstilingue
@onready var icon_sal = %IconeSal
@onready var icon_apito = %iconeapito  # Notei que na imagem está minúsculo
@onready var icon_boneco = %IconeBoneco
@onready var icon_coco = %IconeCoco

@export var gradiente_cor: Gradient

# Função unificada que atualiza TUDO (Termômetro + Itens)
func atualizar_hud(player_ref, sol_atual: float, sol_maximo: float):
	
	# ==========================================
	# 1. ATUALIZA O TERMÔMETRO (Sua lógica antiga)
	# ==========================================
	if termometro:
		termometro.value = sol_atual
		termometro.max_value = sol_maximo
		
		# Muda a cor usando o gradiente
		if gradiente_cor:
			var porcentagem = sol_atual / sol_maximo
			termometro.tint_progress = gradiente_cor.sample(porcentagem)
			
	# ==========================================
	# 2. ATUALIZA OS ITENS (Nova lógica)
	# ==========================================
	
	# O ESTILINGUE: Sempre visível (ou checa variável se quiser)
	if icon_estilingue:
		icon_estilingue.visible = true 
	
	# O SAL: Só aparece se o player tiver sal
	if icon_sal:
		if player_ref.has_salt:
			icon_sal.visible = true
		else:
			icon_sal.visible = false
			
	# O APITO
	if icon_apito:
		if player_ref.has_whistle:
			icon_apito.visible = true
		else:
			icon_apito.visible = false
			
	# O BONECO
	if icon_boneco:
		if player_ref.has_doll:
			icon_boneco.visible = true
		else:
			icon_boneco.visible = false
			
	# O COCO
	if icon_coco:
		if player_ref.cocos_count > 0:
			icon_coco.visible = true
		else:
			icon_coco.visible = false
