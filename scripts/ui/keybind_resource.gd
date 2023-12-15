class_name KeybindResource
extends Resource

# Key constants
const look_up : String = "look_up"
const look_down : String = "look_down"
const look_left : String = "look_left"
const look_right : String = "look_right"

const move_forward : String = "move_forward"
const move_backward : String = "move_backward"
const move_left : String = "move_left"
const move_right : String = "move_right"

const attack : String = "attack"
const reload : String = "reload"
const interact : String = "interact"

const pause : String = "pause"

# Default settings
@export var DEFAULT_LOOK_UP_KEY = InputEventKey.new()
@export var DEFAULT_LOOK_DOWN_KEY = InputEventKey.new()
@export var DEFAULT_LOOK_LEFT_KEY = InputEventKey.new()
@export var DEFAULT_LOOK_RIGHT_KEY = InputEventKey.new()

@export var DEFAULT_MOVE_FORWARD_KEY = InputEventKey.new()
@export var DEFAULT_MOVE_BACKWARD_KEY = InputEventKey.new()
@export var DEFAULT_MOVE_LEFT_KEY = InputEventKey.new()
@export var DEFAULT_MOVE_RIGHT_KEY = InputEventKey.new()

@export var DEFAULT_ATTACK_KEY = InputEventKey.new()
@export var DEFAULT_RELOAD_KEY = InputEventKey.new()
@export var DEFAULT_INTERACT_KEY = InputEventKey.new()

@export var DEFAULT_PAUSE_KEY = InputEventKey.new()

# Customize keybinds
var look_up_key = InputEventKey.new()
var look_down_key = InputEventKey.new()
var look_left_key = InputEventKey.new()
var look_right_key = InputEventKey.new()

var move_forward_key = InputEventKey.new()
var move_backward_key = InputEventKey.new()
var move_left_key = InputEventKey.new()
var move_right_key = InputEventKey.new()

var attack_key = InputEventKey.new()
var reload_key = InputEventKey.new()
var interact_key = InputEventKey.new()

var pause_key = InputEventKey.new()
