class_name StateComponent
extends Node

const COYOTERESET : float = 0.2
const BOUNCERESET : float = 0.2

@export var controlled : bool = false

var grounded : bool = false
var jumping : bool = false
var dashing : bool = false
var sprinting : bool = false
var crouched : bool = false
var climbing : bool = false
var clinging : bool = false
var coyoteTime : float = 0
var bounceTime : float = 0
var last_direction : Vector3 = Vector3.ZERO

