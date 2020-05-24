extends KinematicBody2D

var velocity: Vector2			= Vector2(0,0)

export var GRAVITY:float 		= 750
export var SPEED:float 		= 750
export var JUMP:float 	= 1250

enum STATES {idle, running, jumping}

var current_state = STATES.idle

func _ready():
	pass # Replace with function body.


# _physics_process
func _physics_process(delta):
	
	velocity.y = GRAVITY
	velocity.x = 0
	current_state = STATES.idle
	# Detect up/down/left/right keystate and only move when pressed.
	if Input.is_action_pressed("KEYBOARD_D"):
		velocity.x += SPEED
	if Input.is_action_pressed("KEYBOARD_A"):
		velocity.x -= SPEED
	if Input.is_action_pressed("KEYBOARD_W"):
		velocity.y -= SPEED
	if Input.is_action_pressed("KEYBOARD_S"):
		velocity.y += SPEED
	if Input.is_action_pressed("KEYBOARD_SPACE"):
		velocity.y-=JUMP
	paint_movement(velocity)
		

func paint_movement(aVelocity: Vector2):
	print("Velocidad. X " ,velocity.x)
	print("Velocidad. Y " , velocity.y)
	
	if (aVelocity.x > 0):
		get_node("spr_player_one").flip_h = false
		get_node("player_anim").play("player_one_run")
	if (aVelocity.x < 0):
		get_node("spr_player_one").flip_h = true
		get_node("player_anim").play("player_one_run")			
	if (aVelocity.x == 0 && velocity.y<0):
		get_node("player_anim").play("player_one_jump")
	if (aVelocity.x == 0 && aVelocity.y == GRAVITY ):
		get_node("player_anim").play("idle")
	if (aVelocity.y < GRAVITY):
		print("State jumping")
		get_node("player_anim").play("player_one_jump")

	move_and_slide(velocity)
		
