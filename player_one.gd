extends Position2D

export var gravity:float = 250
export var speed:float = 250
export var jump_speed:float = 200
export var scena_knife:PackedScene
export var spawn_knife: Vector2
var velocity: Vector2
var distance: Vector2
var direction_x =  0
var can_jump:bool
var can_slide:bool
var can_shoot:bool = false
enum STATES {
	idle,
	running,
	jumping,
	sliding
}

var currentState: int = STATES.idle

func _ready():
	# get knife position local for flip the position
	spawn_knife = $body_player_one/position_knife.position
	
	

# _physics_process
func _physics_process(delta):
	# Evitamos camabiar la direccion cuando está saltando.
	if can_jump:
		direction_x = int(Input.is_action_pressed("KEYBOARD_D")) - int(Input.is_action_pressed("KEYBOARD_A"))
	if direction_x > 0:
		$body_player_one/spr_player_one.flip_h = false
		$body_player_one/position_knife.position = spawn_knife
	elif direction_x < 0: 
		$body_player_one/spr_player_one.flip_h = true
		$body_player_one/position_knife.position = Vector2(spawn_knife.x*-1, spawn_knife.y)
		
	distance.x = speed * delta
	velocity.x = (direction_x * distance.x) / delta
	velocity.y += gravity * delta
	
	paint_character()
	
func paint_character():
	if velocity.x !=0 && can_jump:
		$body_player_one/player_anim.play("player_one_run")
		can_slide = true # Only when the characters are moving
	elif velocity.x ==0 && can_jump:
		$body_player_one/player_anim.play("idle")
		can_slide = false
# warning-ignore:return_value_discarded
	#move_and_slide(velocity)
	velocity = $body_player_one.move_and_slide(velocity)
		#if $body_player_one.get_slide_count() > 0:
		#var collision = $body_player_one.get_slide_collision($body_player_one.get_slide_count() - 1)
	for i in $body_player_one.get_slide_count():
		var collision = $body_player_one.get_slide_collision(i)
		print("I collided with ", collision.collider.name)
		# Si estoy en el suelo -> puedo saltar
		if collision.collider.name == "floor":
			can_jump = true
			velocity.y=0	# En el caso de estar en tierra deshabilitamos la gravedad
			if Input.is_action_just_pressed("KEYBOARD_SPACE") && can_jump:
				velocity.y = -jump_speed
				$body_player_one/player_anim.play("player_one_jump")
				can_jump = false
				currentState = STATES.jumping
			if Input.is_action_pressed("KEYBOARD_S") && can_slide:
					$body_player_one/player_anim.play("player_one_slide")
					can_jump = false
					can_slide = false
					currentState = STATES.sliding
		
		if collision.collider.name == "knife_body" && !can_shoot:	#Collision with Knife
			# Remove element knife
			get_tree().get_nodes_in_group("knife")[0].queue_free()
			can_shoot = true
	if Input.is_action_just_pressed("KEYBOARD_N"):
		if can_shoot:
			var new_knife = scena_knife.instance() 	# Instanciamos una escena.
			var fix_movement = direction_x * 20 	# Corregimos la posicion del cuchillo
			# le asignamos al proyectil creado la posicio del proy en el personaje
			new_knife.global_position = Vector2($body_player_one/position_knife.global_position.x + fix_movement, $body_player_one/position_knife.global_position.y)
			# Hay que agregarla como hijo del nodo ppal para que sea indepdte del personaje
			get_tree().get_nodes_in_group("main")[0].add_child(new_knife)
			if $body_player_one/spr_player_one.flip_h:
					new_knife.speed.x = (speed + new_knife.power) * -1
			else:
				new_knife.speed.x = (speed + new_knife.power)
			can_shoot = false
			
		
		
