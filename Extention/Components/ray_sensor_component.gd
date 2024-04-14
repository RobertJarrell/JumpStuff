class_name  RaySensorComponent
extends Node3D

var ankle_collision_detected  : bool = false 
var chest_collision_detected : bool = false
var head_collision_detected : bool = false
var overhead_collision_detected : bool = false
var waist_collision_detected : bool = false
var knee_collision_detected : bool = false
var platform_collision_detected : bool = false
var left_collision_detected : bool = false
var right_collision_detected : bool = false

@onready var head = $Head
@onready var over_head_rays = $OverHeadRays
@onready var head_rays = $HeadRays
@onready var chest_rays = $ChestRays
@onready var ankle_rays = $AnkleRays
@onready var knee_rays = $KneeRays
@onready var waist_rays = $WaistRays
@onready var left_rays = $LeftRays
@onready var right_rays = $RightRays
@onready var platform_rays = $PlatformRays



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	
	overhead_collision_detected = check_collision(over_head_rays)
	head_collision_detected = check_collision(head_rays)
	chest_collision_detected = check_collision(chest_rays)
	ankle_collision_detected = check_collision(ankle_rays)
	knee_collision_detected = check_collision(knee_rays)
	waist_collision_detected = check_collision(waist_rays)
	left_collision_detected = check_collision(left_rays)
	right_collision_detected = check_collision(right_rays)
	

#set collision detect variables
func check_collision(ray_array : Node3D) -> bool:
	var detected :bool = false
	for child in ray_array.get_children():
		var ray = child as RayCast3D
		if ray.is_colliding():
			detected = true
			return detected
	
	return detected
	

#Query for a collision normal
func get_normal(ray_array : Node3D) -> Vector3:
	var surface_normal : Vector3 = Vector3.ZERO
	for child in ray_array.get_children():
		var ray = child as RayCast3D
		if ray.is_colliding():
			surface_normal = ray.get_collision_normal()
			return surface_normal
	return surface_normal
