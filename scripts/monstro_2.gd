extends CharacterBody3D

const SPEED := 100.0
const CHASE_RANGE:= 4.0

@export var alvo : CharacterBody3D
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D


func _process(delta: float) -> void:
	velocity = Vector3.ZERO
	
	
	if global_position.distance_to(alvo.global_position) < CHASE_RANGE:
		navigation_agent_3d.set_target_position(alvo.global_transform.origin)
		var next_nav_point = navigation_agent_3d.get_next_path_position()
		velocity = (next_nav_point - global_transform.origin).normalized() * SPEED * delta
		
	move_and_slide()
