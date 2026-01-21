extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var lastV = Vector2.ZERO
var health = 20
var startHealth = 20
var startTime
var wait
var kill = false
func _ready() -> void:
	if wait == null:
		wait = false
	if velocity.x ==0:
		velocity.x = 200
	startTime = Time.get_ticks_msec()
	health = startHealth
	$Health.text = str(health)

	$Circle.modulate = Color.from_hsv(fmod(startHealth * 0.2, 1.0), 1.0, 1.0)
	$Circle/inner.visible = startHealth >1
	var c = Color.from_hsv(fmod(startHealth * 0.2, 1.0), 1.0, 1.0)
	c.a = 0.5
	$Circle/inner.modulate= c#$Circle/inner.modulate.darkened(0.3)
func _physics_process(delta: float) -> void:
	if (Time.get_ticks_msec() - startTime > 100 or not wait) and not kill:
		$Circle/inner.scale = Vector2(float(health)/float(startHealth),float(health)/float(startHealth))
		$Health.text = str(health)
		if health <1:
			$"..".addToScore()
			if startHealth >1 :
				var s = $"..".getBallScale(startHealth/2)
				var child = $"..".ball.instantiate()
				child.health = startHealth/2
				child.startHealth = startHealth/2
				#child.scale = 0.8*scale
				child.scale = Vector2(s,s)
				child.velocity.x = -200
				child.position = position-Vector2(20,0)
				child.position.y = 102
				$"..".add_child(child)
				child = $"..".ball.instantiate()
				child.health = startHealth/2
				child.startHealth = startHealth/2
				#child.scale = 0.8*scale
				child.scale = Vector2(s,s)
				child.position = position+Vector2(20,0)
				child.position.y = 102
				$"..".add_child(child)
			$Circle.hide()
			$Health.hide()
			kill = true
			var c = Color.from_hsv(fmod(startHealth * 0.2, 1.0), 1.0, 1.0)
			c.a = 0.5
			$"..".addExplode(position,c.darkened(0.3))
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta *2
			lastV.y = velocity.y
		else:
			for i in get_slide_collision_count():
				if get_slide_collision(i).get_collider().is_in_group("player"):
					$"../Player".restart()
			velocity.y = - lastV.y
			$"../SFX/bounce".pitch_scale = RandomNumberGenerator.new().randf_range(1,1.4)
			$"../SFX/bounce".play()
		rotate(deg_to_rad(velocity.x/100)*Engine.time_scale)
		if is_on_wall():
			velocity.x = -lastV.x
			for i in get_slide_collision_count():
				if get_slide_collision(i).get_collider().is_in_group("player"):
					$"../Player".restart()
			$"../SFX/bounce".pitch_scale = RandomNumberGenerator.new().randf_range(1,1.4)
			$"../SFX/bounce".play()
		else:
			lastV.x = velocity.x
		move_and_slide()
	elif kill:
		$"../SFX/pop".play()
		queue_free()
	else:
		health = startHealth
