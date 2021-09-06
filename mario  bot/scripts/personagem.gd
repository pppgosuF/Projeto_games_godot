extends KinematicBody2D

onready var rayE = get_node("rayE")
onready var rayD = get_node("rayD")
onready var sprite = get_node("sprite")

var vivo = true
signal morreu

#---------------------------------------------------------------------------------------------

# This demo shows how to build a kinematic controller.

# Member variables
const GRAVITY = 1100.0 # pixels/second/second

# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 600
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 200
const STOP_FORCE = 1300
const JUMP_SPEED = 800
const JUMP_MAX_AIRBORNE_TIME = 0.2

const SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # one pixel

var velocity = Vector2()
var on_air_time = 100
var jumping = false

var prev_jump_pressed = false


func _physics_process(delta):
	# Create forces
	var force = Vector2(0, GRAVITY)
	
	var walk_left = Input.is_action_pressed("move_left") and vivo
	var walk_right = Input.is_action_pressed("move_right") and vivo
	var jump = Input.is_action_pressed("jump") and vivo
	
	var stop = true
	
	if walk_left:
		if velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED:
			force.x -= WALK_FORCE
			stop = false
	elif walk_right:
		if velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED:
			force.x += WALK_FORCE
			stop = false
	
	if stop:
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= STOP_FORCE * delta
		if vlen < 0:
			vlen = 0
		
		velocity.x = vlen * vsign
	
	# Integrate forces to velocity
	velocity += force * delta	
	# Integrate velocity into motion and move
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if is_on_floor():
		on_air_time = 0
		
	if jumping and velocity.y > 0:
		# If falling, no longer jumping
		jumping = false
	
	if on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not prev_jump_pressed and not jumping:
		# Jump must also be allowed to happen if the character left the floor a little bit ago.
		# Makes controls more snappy.
		pular()
	
	on_air_time += delta
	prev_jump_pressed = jump
	
	var no_chao = rayE.is_colliding() or rayD.is_colliding()
	
	if walk_right:
		sprite.set_flip_h(false)
	if walk_left:
		sprite.set_flip_h(true)
	
	if (walk_left or walk_right) and no_chao:
		sprite.play()
	elif (walk_left or walk_right):
		sprite.stop()
		sprite.set_frame(2)
	else:
		sprite.stop()
		sprite.set_frame(1)
	
	if get_position().y > 900: morreu()
	
func _on_pes_body_entered(body):
	pular()
	body.esmagar()
	
func pular():
	velocity.y = -JUMP_SPEED
	jumping = true
	


func _on_corpo_body_entered(body):
	print("morreu")

func morreu():
	if not vivo: return
	vivo = false 
	velocity.y = - 500
	get_node("shape").set_deferred("disabled", true )
	emit_signal("morreu")