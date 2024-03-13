class_name CharacterBodyController
extends Node

@export var state : StateComponent
@export var model : CharacterBody3D

signal move(direction : Vector3, delta : float)
signal jump()
signal action(direction : Vector3, delta : float)
signal apply_gravity(delta : float)
signal current_direction(direction : Vector3, delta : float)
signal facing(direction : Vector3)

func _physics_process(delta):
	
	if state.controlled:
		_get_input(delta)
	
	

func _get_input(delta):
	var input_direction = Input.get_vector("Left","Right","Forward","Backward")
	var raw_direction = Vector3(input_direction.x, 0, input_direction.y)
	var direction = (model.transform.basis * raw_direction).normalized()
	
	if direction:
		current_direction.emit(direction, delta)
	
	if Input.is_action_just_pressed("Jump"):
		jump.emit()
		
	if Input.is_action_pressed("Action"):
		action.emit(direction)
	
	if state.grounded:
		if state.bounceTime > 0:
			jump.emit()
		else:
			move.emit(direction, delta)
			
		facing.emit(direction)
		
	if !state.grounded:
		
		if !state.climbing && !state.clinging && !state.dashing:
			apply_gravity.emit(delta)
	
	if !Input.is_action_pressed("Action"):
		state.sprinting = false
		
	if direction:
		state.last_direction = direction

