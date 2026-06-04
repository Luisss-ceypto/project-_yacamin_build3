extends StaticBody3D

var ta_abrido: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func interacao()-> void:
	if animation_player.is_playing():
		return
		
	if not ta_abrido:
		animation_player.play("abrido")
		ta_abrido = true
	#else:
		#animation_player.play("fechar")
		#ta_abrido = false
