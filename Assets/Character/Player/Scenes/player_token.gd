class_name PlayerToken
extends CharacterBody3D

@export var controller : CharacterBodyController
@export var state : StateComponent


@onready var visuals = $Visuals
@onready var upper = $Upper

func _ready():
	
	controller.facing.connect(face_toward)
	
	
func _physics_process(delta):
	
	crouch()
	
	if state.coyoteTime > 0:
		state.coyoteTime += -delta
	
	state.grounded = is_on_floor()
	
	move_and_slide()
	
	var just_left_ground = state.grounded and not is_on_floor()
	
	if just_left_ground:
		state.coyoteTime = state.COYOTERESET
	

func _check_overhead() -> bool:
	var result : bool = false
	var space_state = get_world_3d().direct_space_state
	var over_head = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(position, position + Vector3(0,2,0), 1, [self]))
	if over_head:
		result = true
	return result

func crouch():
	if !state.crouched && Input.is_action_just_pressed("Crouch"):
		upper.disabled = true
		state.crouched = true
		
	if state.crouched && !Input.is_action_pressed("Crouch"):
		if not _check_overhead():
			upper.disabled = false
			state.crouched = false

func face_toward(direction : Vector3):
	if direction:
		visuals.look_at(direction + global_position)
	

