extends CharacterBody2D

const WALKING_SPEED = 400.0
const DASH_SPEED = 3000
const DASH_TIME = 0.09
const DASH_COOLDOWN = 1.8
var angle_towards_mouse = 0
var dash_direction = facing
var can_dash = true
var is_dashing = false
var time = 0
var cooldown = 0
var mouse_location_reletive_to_player = Vector2(0,0)

func _physics_process(delta):
	player_movement(delta)
	player_attack(delta)


func player_movement(delta):
	facing()
	walking()
	dash_handler(delta)
	move_and_slide()

func player_attack(delta):
	primary_attack(delta)
	secondary_attack(delta)
	
func primary_attack(delta):
	if(Input.is_action_pressed("primary_attack")):
		print("primary attack")
		
func secondary_attack(delta):
	if(Input.is_action_pressed("secondary_attack")):
		print("secondary attack")

func facing():
	angle_towards_mouse = position.angle_to_point(get_viewport().get_mouse_position())
	mouse_location_reletive_to_player = get_viewport().get_mouse_position() - position
	#print(angle_towards_mouse)

func walking():
	if(!is_dashing):
		var direction_x = Input.get_axis("left", "right")
		var direction_y = Input.get_axis("up", "down")
		if (direction_x or direction_y):
			velocity.x = direction_x * WALKING_SPEED
			velocity.y = direction_y * WALKING_SPEED
			$AnimationPlayer.pause()
		else:
			velocity.x = move_toward(velocity.x, 0, WALKING_SPEED)
			velocity.y = move_toward(velocity.y, 0, WALKING_SPEED)
			$AnimationPlayer.play("idle")
	
func dash_handler(delta):
	if Input.is_action_pressed("dash"):
		if(can_dash):
			is_dashing = true
			dash_direction = mouse_location_reletive_to_player
			$"dash particles".rotation = angle_towards_mouse - PI
			$"dash particles".emitting = true
			print(dash_direction)
		
	if(is_dashing):
		can_dash = false
		time += delta
		if time < DASH_TIME:
			velocity = dash_direction.normalized() * DASH_SPEED
			print("dashing")
		else:
			print("timer finshed")
			is_dashing = false
			time = 0
			$"dash particles".emitting = false
			velocity = Vector2(0,0)
				
	if(!can_dash):
		cooldown += delta
		if cooldown > DASH_COOLDOWN:
			can_dash = true
			print("can dash")
			cooldown = 0
