extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = $"../Pause".visible or $"../Leaderboard".visible



func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		hide()
		$"../Leaderboard".hide()
		$"../Pause".hide()
		Engine.time_scale = 1
