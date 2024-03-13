class_name TumbleComponent
extends Node

const DASH_TIME_RESET : float = 0.2

@export var model : CharacterBody3D
@export var state : StateComponent
@export var controller : CharacterBodyController

var can_dash : bool = true
var isdashing : bool = false
var air_dashing : bool = false
var air_modifier : float = 0.5
var dashTime : float = 0.2

var dash_speed : float

# Called when the node enters the scene tree for the first time.
func _ready():
	
	dash_speed = 15.0
	controller.action.connect(handle_dashing)
	

func _physics_process(delta):
	
	if state.sprinting and model.is_on_wall():
		var dash_direction = (-model.get_last_slide_collision().get_normal() + state.last_direction).normalized()
		_hop_tween()
		dashTime *= 2.0
		_dash_movement(dash_direction)
		
		
	
		
	if state.dashing and dashTime > 0.0:
		dashTime += -delta
		
	
	if dashTime < 0.0 || !state.dashing:
		isdashing = false
		air_dashing = false
		state.dashing = false
		dashTime = DASH_TIME_RESET
		
	
	if state.grounded:
		
		can_dash = true
	
	

func _dash_movement(direction : Vector3, modifier : float = 1.0):
	
	state.dashing = true
	can_dash = false
	model.velocity = direction * dash_speed * modifier
	
	

func _hop_tween():
	
	model.velocity = Vector3.ZERO
	state.sprinting = false
	state.climbing = true
	var hop = model.global_transform.origin + Vector3(0, 1.0, 0)
	var hop_tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	
	hop_tween.tween_property(model,"global_transform:origin", hop, 0.2)
	
	await hop_tween.finished
	
	state.climbing = false
	

func handle_dashing(current_direction : Vector3):
	
	var dash_direction : Vector3 = Vector3.ZERO
	
	if current_direction:
		dash_direction = current_direction
	else:
		if state.last_direction:
			dash_direction = state.last_direction
		else:
			dash_direction = (model.global_transform.basis * Vector3.FORWARD).normalized()
	
	
	if can_dash and !state.climbing  and !state.clinging:
		if !state.grounded:
			if model.is_on_wall():
				var wall_normal = -model.get_last_slide_collision().get_normal().normalized()
				dash_direction = wall_normal + dash_direction
				
				if dash_direction == Vector3(2,0,0) || dash_direction == Vector3(-2,0,0) || dash_direction == Vector3(0,0,2) || dash_direction == Vector3(0,0,-2):
					dash_direction += Vector3.UP
				isdashing = true
				
			
			else:
				if Input.is_action_pressed("Jump"):
					air_dashing = true
					dash_direction = current_direction + Vector3.UP
					
				else:
					isdashing = true
					
		else:
			if Input.is_action_pressed("Crouch"):
				isdashing = true
				
				
			
		
		
		if air_dashing:
			_dash_movement(dash_direction, air_modifier)
		elif isdashing:
			_dash_movement(dash_direction)
	
	if !state.dashing and state.grounded:
		state.sprinting = true
		

