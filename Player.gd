extends RigidBody2D

const jump_impulses = [-110 * 2, -90 * 2]
const max_jumps = 2
const ground_speed = 20
const air_speed = 10
const max_ground_speed = 170
const max_air_speed = 100
const ground_damping = 0.7
const air_damping = 0.95

var jumps = 0

func _ready():
	mode = RigidBody2D.MODE_CHARACTER
	friction = 0
	gravity_scale = 3

func _physics_process(delta):
	if is_grounded():
		jumps = 0
	
	var horizontal = 1 if Input.is_action_pressed("ui_right") else 0 - 1 if Input.is_action_pressed("ui_left") else 0
	
	# damp when no move input
	var damping = ground_damping if is_grounded() else air_damping
	linear_velocity = Vector2(linear_velocity.x * (1 if abs(horizontal) else damping), linear_velocity.y)
	
	# move
	var speed = ground_speed if is_grounded() else air_speed
	var max_speed = max_ground_speed if is_grounded() else max_air_speed
	var impulse = speed * horizontal * delta
	impulse *= min(max_speed, max(0, max_speed - linear_velocity.x * horizontal))
	apply_central_impulse(Vector2(impulse, 0))

	# jump
	if Input.is_action_just_pressed("ui_up") and jumps < max_jumps:
		impulse = min(0, jump_impulses[jumps] - linear_velocity.y)
		apply_central_impulse(Vector2(0, impulse))
		jumps += 1
	
func is_grounded():
	return linear_velocity.y == 0
