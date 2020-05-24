extends KinematicBody2D

export var speed:Vector2
export var power:int
func _ready():
	speed.x = 0
	speed.y = 0
	

func _physics_process(delta):
	var movement = speed * delta
	$animation_knife.play("launch")
	move_and_slide(speed)
	
	#If collision with another element. the knife is stopped
	if get_slide_count() > 0:
		$animation_knife.play("Idle_knife")
		speed.y = 250
		#var collision = get_slide_collision($body_player_one.get_slide_count() - 1)
		#if collision.collider.name == "floor":
