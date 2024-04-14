class_name MoveComponent
extends Node

@export var model : CharacterBody3D
@export var state : StateComponent
@export var controller : CharacterBodyController

var base_speed : float

var sprint_modifier : float = 1.5
var crouch_modifier : float = 0.25
var air_modifier : float = 0.75
var acceleration : float = 2.5
var friction : float = .2
var last_direction : Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	
	base_speed = 5.0
	
	controller.current_direction.connect(confirm_direction)
	controller.move.connect(handle_move)
	

func _move(direction : Vector3, current_speed : float, delta : float):
	if direction:
		
		model.velocity.x = lerp(model.velocity.x, direction.x * current_speed, acceleration * delta)
		model.velocity.z = lerp(model.velocity.z, direction.z * current_speed, acceleration * delta)
		
		#if sprinting, spend stamina
		
	else:
		model.velocity.x = move_toward(model.velocity.x, 0, current_speed * friction)
		model.velocity.z = move_toward(model.velocity.z, 0, current_speed * friction)
		
	last_direction = direction
	
func _air_move(direction : Vector3):
	var speed = base_speed * air_modifier
	
	model.velocity.x = direction.x * speed
	model.velocity.z = direction.z * speed
	
	last_direction = direction
	

func handle_move(current_direction : Vector3, delta : float):
	var speed : float
	if !state.dashing && !state.clinging && !state.climbing:
		
		if state.crouched:
			speed = base_speed * crouch_modifier
		
		elif state.sprinting:
			speed = base_speed * sprint_modifier
		
		else:
			speed = base_speed
		
		_move(current_direction, speed, delta)
		
	

func confirm_direction(current_direction : Vector3, delta : float):
	if !state.grounded and !state.clinging  and !state.climbing and !state.dashing:
		if current_direction != last_direction && current_direction != Vector3.ZERO:
			_air_move(current_direction)
		
	




