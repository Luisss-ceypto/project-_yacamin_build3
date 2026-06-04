extends Node

@export var sun_light: DirectionalLight3D
@export var world_environment:WorldEnvironment
@export var dia_duracao: float = 2.0
@export var label: Label

@export var tempo_dia: float = 0.0

func _ready() -> void:
	sun_light.rotation_degrees.x = tempo_dia


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	tempo_dia += delta / dia_duracao
	if tempo_dia >= 1.0:
		tempo_dia -= 1.0
		
	sun_light.rotation_degrees.x = tempo_dia * 360.0
	_atualizar_environment()
	
	label.text = hora()
	
func _atualizar_environment() -> void:
	var deg_x: float = sun_light.rotation_degrees.x
	
	if is_daytime(deg_x):
		var intensity = sun_intensity(deg_x)
		sun_light.light_energy = intensity
		
	
func is_daytime(deg_x: float)-> bool:
	return deg_x > 90.0 and deg_x < 270.0
	
func is_nighttime(deg_x: float)-> bool:
	return not is_daytime(deg_x)
	
func sun_intensity(deg_x: float)-> float:
	var normalize = (deg_x - 90.0) / 180
	
	return sin(normalize * PI)
	

func hora() -> String:
	var total_minutes: int = int(tempo_dia * 24.0 * 60.0)
	var hora_24: int = total_minutes / 60
	var minuto: int = total_minutes % 60
	
	var am_pm: String = "AM" if hora_24 < 12 else  "PM"
	var hora_12: int = hora_24 % 12
	if hora_12 == 0:
		hora_12 = 12
		
	return "%d:%02d %s" % [hora_12, minuto, am_pm]
	
	
	
	
