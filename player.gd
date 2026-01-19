extends CharacterBody2D


const SPEED = 1200.0
const JUMP_VELOCITY = -400.0
var bullet
var restarting = false
func _ready() -> void:
	bullet = preload("res://bullet.tscn")

var lastShoot = Time.get_ticks_msec()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta/1.5

	if Input.is_action_pressed("shoot") and Time.get_ticks_msec()-lastShoot > 100 and Engine.time_scale == 1:
		lastShoot = Time.get_ticks_msec()
		var child = bullet.instantiate()
		child.position = position+Vector2(0,-10)
		$"..".add_child(child)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var direction = Input.get_axis("Left", "Right")
	var mousePos =  get_viewport().get_mouse_position() 
	if Input.is_action_pressed("mouseLeft") and abs(position.x -mousePos.x) >10 and Engine.time_scale == 1:
		
		if mousePos.x> position.x:
			direction = 1
		else:
			direction = -1
		direction = mousePos.x - position.x
	else:
		direction *= 100
	if direction:
		velocity.x = direction/100 * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func restart():
	if not restarting and get_tree():
		restarting =true
		$"..".restart()
