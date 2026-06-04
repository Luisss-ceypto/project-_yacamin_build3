extends CharacterBody3D

var speed

const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 4.5
const SENSIBILIDADE = 0.01

const freq = 2.0
const amp = 0.08
var t_bob = 0.0

const fov_base = 75.0
const fov_mudar = 1.5

var gravidade = 9.8

@onready var cabeca: Node3D = $cabeca
@onready var camera: Camera3D = $cabeca/camera
@onready var capacete_1: Node3D = $cabeca/camera/capacete1
@onready var ray: RayCast3D = $cabeca/camera/RayCast3D
@onready var spot_light_3d: SpotLight3D = $cabeca/camera/SpotLight3D



func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Inventario.item_drop.connect(drop_item_from_player)
	PlayerManager.player = self


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		cabeca.rotate_y(-event.relative.x * SENSIBILIDADE)
		camera.rotate_x(-event.relative.y * SENSIBILIDADE)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	ligar_lanterna()
	ray_scaning(delta)
	pulo_E_gravidade(delta)
	mover_E_correr(delta)
	move_and_slide()


func  _cabecaBob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * freq) * amp
	pos.x = cos(time * freq / 2) * amp
	return pos


func mover_E_correr(delta: float)-> void:
	if Input.is_action_pressed("correr"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
		
	var input_dir := Input.get_vector("esquerda", "direita", "frente", "tras")
	var direction := (cabeca.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
		
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
		
	
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _cabecaBob(t_bob)
	
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = fov_base + fov_mudar * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 10.0)


func pulo_E_gravidade(delta:float)-> void:
	if not is_on_floor():
		velocity.y -= gravidade * delta
	
	if Input.is_action_just_pressed("pular") and is_on_floor():
		velocity.y = JUMP_VELOCITY


func ray_scaning(_delta)->void:
	if ray.is_colliding():
		var colider = ray.get_collider()
		if colider == null:
			return
		
		if Input.is_action_just_pressed("interagir"):
			print("ta colidindo com "+ colider.name)
			
			if colider.is_in_group("interactable"):
				colider.interacao()


func drop_item_from_player(item):
	var forward = -transform.basis.x.normalized()
	var drop_pos = global_position + forward * 2.0
	item.global_position = drop_pos

func ligar_lanterna()-> void:
	if Input.is_action_just_pressed("ligar_lanterna"):
		spot_light_3d.visible = true
	elif Input.is_action_just_pressed("desligar_lanterna"):
		spot_light_3d.visible = false
