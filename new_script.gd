extends KinematicBody2D

export var gravity:float = 250
export var speed:float = 250
export var jump_speed:float = 150

var velocity: Vector2 = Vector2()
var distance: Vector2 = Vector2()
var direction_x =  0
var canjump_speed: bool = true

enum STATES {
	idle,
	running,
	jumping
}

var currentState: int = STATES.idle

func _ready():
	pass # Replace with function body.

# _physics_process
func _physics_process(delta):
	$player_anim.play("idle")
	direction_x = int(Input.is_action_pressed("KEYBOARD_D")) - int(Input.is_action_pressed("KEYBOARD_A"))
		
	if(direction_x<0):
		$spr_player_one.flip_h = true
		$player_anim.play("player_one_run")
	if direction_x>0:
		$spr_player_one.flip_h = false
		$player_anim.play("player_one_run")
	if direction_x == 0:
		$player_anim.play("idle")
			
	
	distance.x = speed * delta
	velocity.x = (direction_x * distance.x) / delta
	velocity.y += gravity * delta
	
	move_and_slide(velocity)
	velocity = move_and_slide(velocity)
	if get_slide_count() > 0:
		var collision = get_slide_collision(get_slide_count() - 1)
		if collision.collider.name == "floor":
		# En el caso de estar en tierra deshabilitamos la gravedad
			velocity.y=0
			if Input.is_action_just_pressed("KEYBOARD_SPACE"):
				velocity.y = -jump_speed
