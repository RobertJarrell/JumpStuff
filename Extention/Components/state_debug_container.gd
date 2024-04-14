class_name StateDebugContainer
extends GridContainer

@export var state = StateComponent

var current_controlled_value : bool
var current_grounded_value : bool
var current_dashing_value : bool
var current_sprinting_value : bool
var current_crouched_value : bool
var current_climbing_value : bool
var current_clinging_value : bool
var current_coyote_time_value : float
var current_bounce_time_value : float
var current_last_direction_value : Vector3


@onready var controlled     = $Controlled    as DebugValues
@onready var grounded       = $Grounded      as DebugValues
@onready var dashing        = $Dashing       as DebugValues
@onready var sprinting      = $Sprinting     as DebugValues
@onready var crouched       = $Crouched      as DebugValues
@onready var climbing       = $Climbing      as DebugValues
@onready var clinging       = $Clinging      as DebugValues
@onready var coyote_time    = $CoyoteTime    as DebugValues
@onready var bounce_time    = $BounceTime    as DebugValues
@onready var last_direction = $LastDirection as DebugValues


# Called when the node enters the scene tree for the first time.
func _ready():
	
	_update_tracked_value(controlled, state.controlled)
	_update_tracked_value(grounded, state.grounded)
	_update_tracked_value(dashing, state.dashing)
	_update_tracked_value(sprinting, state.sprinting)
	_update_tracked_value(crouched, state.crouched)
	_update_tracked_value(climbing, state.climbing)
	_update_tracked_value(clinging, state.clinging)
	_update_tracked_value(coyote_time, state.coyoteTime)
	_update_tracked_value(bounce_time, state.bounceTime)
	_update_tracked_value(last_direction, state.last_direction)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_handle_value_changes()
	

func _update_tracked_value(tracked_value : DebugValues, value):
	
	var new_value = tracked_value.value_tag as Label
	
	new_value.text = str(value)
	

func _handle_value_changes():
	if current_controlled_value != state.controlled:
		current_controlled_value = state.controlled
		_update_tracked_value(controlled, state.controlled)
		
	if current_grounded_value != state.grounded:
		current_grounded_value = state.grounded
		_update_tracked_value(grounded, state.grounded)
		
	if current_dashing_value != state.dashing:
		current_dashing_value = state.dashing
		_update_tracked_value(dashing, state.dashing)
		
	if current_sprinting_value != state.sprinting:
		current_sprinting_value = state.sprinting
		_update_tracked_value(sprinting, state.sprinting)
		
	if current_climbing_value != state.climbing:
		current_climbing_value = state.climbing
		_update_tracked_value(climbing, state.climbing)
		
	if current_clinging_value != state.clinging:
		current_clinging_value = state.clinging
		_update_tracked_value(clinging, state.clinging)
		
	if current_crouched_value != state.crouched:
		current_crouched_value = state.crouched
		_update_tracked_value(crouched, state.crouched)
		
	if current_coyote_time_value != state.coyoteTime:
		current_coyote_time_value = state.coyoteTime
		_update_tracked_value(coyote_time, state.coyoteTime)
		
	if current_bounce_time_value != state.bounceTime:
		current_bounce_time_value = state.bounceTime
		_update_tracked_value(bounce_time, state.bounceTime)
		
	if current_last_direction_value != state.last_direction:
		current_last_direction_value = state.last_direction
		_update_tracked_value(last_direction, state.last_direction)
		
	
