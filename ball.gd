extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var lastV = Vector2.ZERO
var health = 20
var startHealth = 20

func _ready() -> void:
	if velocity.x ==0:
		velocity.x = 200
	health = startHealth
func _physics_process(delta: float) -> void:
	$Health.text = str(health)
	if health <1:
		if startHealth >1 :
			var child = $"..".ball.instantiate()
			child.health = startHealth/2
			child.startHealth = startHealth/2
			child.scale = 0.8*scale
			child.velocity.x = -200
			child.position = position-Vector2(20,0)
			child.position.y = 102
			$"..".add_child(child)
			child = $"..".ball.instantiate()
			child.health = startHealth/2
			child.startHealth = startHealth/2
			child.scale = 0.8*scale
			child.position = position+Vector2(20,0)
			child.position.y = 102
			$"..".add_child(child)
		queue_free()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta *2
		lastV.y = velocity.y
	else:
		for i in get_slide_collision_count():
			if get_slide_collision(i).get_collider().is_in_group("player"):
				$"../Player".restart()
		velocity.y = - lastV.y
	rotate(deg_to_rad(velocity.x/100))
	if is_on_wall():
		velocity.x = -lastV.x
		for i in get_slide_collision_count():
			if get_slide_collision(i).get_collider().is_in_group("player"):
				$"../Player".restart()
	else:
		lastV.x = velocity.x
	move_and_slide()
