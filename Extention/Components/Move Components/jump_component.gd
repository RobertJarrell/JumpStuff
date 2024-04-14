class_name JumpComponent
extends Node

const hangtimeRESET : float = 0.4

@export var model : CharacterBody3D
@export var state : StateComponent
@export var controller : CharacterBodyController

var jump_strength : float

var fall_off : float = 1.0
var hangtime : float = 0.0
var jump_count : int = 1
var jump_count_reset : int = 1
var has_jumped : bool = false
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


# Called when the node enters the scene tree for the first time.
func _ready():
	
	jump_strength = 4.5
	
	controller.jump.connect(handle_jumping)
	controller.apply_gravity.connect(handle_gravity)
	

func _physics_process(delta):
	
	if hangtime > 0.0:
		hangtime += -delta
		
	if state.bounceTime > 0:
		state.bounceTime += -delta
	
	if state.grounded:
		jump_count = jump_count_reset
		has_jumped = false


func _jump(air_jump : bool = false, wall_jumping : bool = false, normal : Vector3 = Vector3.ZERO):
	if !wall_jumping:
		model.velocity.y = lerp(model.velocity.y, jump_strength, hangtimeRESET)
		if air_jump:
			jump_count -= 1
		hangtime = hangtimeRESET
		has_jumped = true
	
	else:
		var push_force = jump_strength * 0.5
		var jump_direction : Vector3 = Vector3(normal.x * push_force, jump_strength , normal.z * push_force)
		model.velocity = jump_direction
		state.last_direction = normal
		controller.facing.emit(normal)
		hangtime = hangtimeRESET
		
	


func _gravity(delta : float, gravity_modifier : float = 1):
	
		model.velocity.y += -gravity * delta * gravity_modifier
		

func handle_jumping():
	
	if !state.climbing && !state.clinging:
		
		
		if state.grounded || !state.grounded && state.coyoteTime > 0:
			_jump()
		
		elif model.is_on_wall():
			var wall_normal : Vector3 = model.get_slide_collision(0).get_normal()
			_jump(false, true, wall_normal)	
		
		elif jump_count > 0:
			_jump(true)
		
		else:
			state.bounceTime = state.BOUNCERESET
	

func handle_gravity(delta):
	var weight : float = 3.0
	if model.velocity.y < fall_off||model.velocity.y > 0 and not Input.is_action_pressed("Jump")||hangtime < 0.0:
		if hangtime > hangtimeRESET * 0.5 || !has_jumped:
			_gravity(delta)
		else:
			_gravity(delta, weight)
		
	
