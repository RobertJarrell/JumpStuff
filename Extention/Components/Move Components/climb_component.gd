class_name ClimbComponent
extends Node

@export var sensor : RaySensorComponent
@export var model : CharacterBody3D
@export var state : StateComponent
@export var controller : CharacterBodyController

var step_detected : bool = false
var low_obstacle_detected : bool = false
var high_obstacle_detected : bool = false
var low_wall_detected : bool = false
var wall_ledge_detected : bool = false
var ledge_detected : bool = false
var bar_detected : bool = false
var step_height : float = 0.25
var short_distance : float = 0.3
var hop_height : float = 0.5
var mid_distance : float = 0.5
var high_hop_height : float = 0.8
var vault_height : float = 1.2
var climb_height : float = 1.85
var long_distance : float = 0.75
var quick_time : float = 0.1
var mid_time : float = 0.2
var slow_time : float = 0.4

# Called when the node enters the scene tree for the first time.
func _ready():
	
	controller.action.connect(handle_active_vaulting.unbind(1))
	controller.current_direction.connect(drop.unbind(1))
	

func _physics_process(_delta):
	if state.grounded:
		_ground_evaluation()
	
	else:
		_air_evaluation()
	
	_handle_auto_vaulting()
	

func _ground_evaluation():
	
	if !sensor.overhead_collision_detected && !state.climbing:
		if sensor.chest_collision_detected:
			if sensor.head_collision_detected:
				wall_ledge_detected = true
			else:
				low_wall_detected = true
		elif sensor.ankle_collision_detected:
			if sensor.waist_collision_detected:
				high_obstacle_detected = true
			elif sensor.knee_collision_detected:
				low_obstacle_detected = true
			else:
				step_detected = true
	
	else:
		wall_ledge_detected = false
		low_wall_detected = false
		high_obstacle_detected = false
		low_obstacle_detected = false
		step_detected = false
		
	

func _air_evaluation():
	if !sensor.overhead_collision_detected && !state.climbing:
		if sensor.head_collision_detected and !sensor.chest_collision_detected:
			bar_detected = true
		elif sensor.chest_collision_detected:
			ledge_detected = true
			
	else:
		bar_detected = false
		ledge_detected = false
		
	
	
func _handle_auto_vaulting():
	
	if state.grounded:
		if step_detected:
			_reposition_tween(step_height,short_distance, quick_time, quick_time)
		elif low_obstacle_detected:
			_reposition_tween(hop_height, mid_distance, quick_time, quick_time)
			
	else:
		if ledge_detected:
			print("vaulting")
			_reposition_tween(vault_height, long_distance, mid_time, mid_time)
		
		if bar_detected:
		
			_cling()
		
	

func _reposition_tween(height, distance, v_time, h_time):
	
	model.velocity = Vector3.ZERO
	if state.dashing:
		state.dashing = false
	state.climbing = true
	
	var vertical_movement = model.global_transform.origin + Vector3(0,height,0)
	var vm_tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	
	vm_tween.tween_property(model,"global_transform:origin", vertical_movement, v_time)
	
	await vm_tween.finished
	
	var forward_movement = model.global_transform.origin + (state.last_direction * distance)
	
	var fm_tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	
	fm_tween.tween_property(model, "global_transform:origin", forward_movement, h_time)
	
	state.climbing = false
	

func _cling():
	
	model.velocity = Vector3.ZERO
	if state.dashing:
		state.dashing = false
	state.clinging = true
	

func drop(current_direction : Vector3):
	
	if state.clinging and current_direction == Vector3(0, 0, -1):
		bar_detected = false
		model.velocity = Vector3.DOWN
		state.clinging = false
		
	

func handle_active_vaulting():
	if state.grounded:
		if high_obstacle_detected:
			_reposition_tween(high_hop_height, mid_distance, mid_time, mid_time)
			
		if low_wall_detected:
			_reposition_tween(vault_height, long_distance, mid_time, mid_time)
			
		if wall_ledge_detected:
			_reposition_tween(climb_height, long_distance, slow_time, mid_time)
			
		
	else:
		if state.clinging:
			sensor.check_collision(sensor.platform_rays)
			if sensor.platform_collision_detected:
				_reposition_tween(climb_height, long_distance, slow_time, mid_time)
				bar_detected = false
				state.clinging = false
			
	
