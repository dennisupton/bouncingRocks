extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position.y += -50
	if colliding():
		$"../SFX/hit".play()
		colliding().health -= 1
		queue_free()
	elif position.y < 0:
		queue_free()


func colliding():
	for i in $Area2D.get_overlapping_bodies():
		if i.is_in_group("ball"):
			return i
	return false
