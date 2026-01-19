extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Circle.modulate = Color.RED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position.y += -50
	if $RayCast2D.is_colliding() and $RayCast2D.get_collider().is_in_group("ball"):
		$RayCast2D.get_collider().health -= 1
		queue_free()
	elif position.y < 0:
		queue_free()
