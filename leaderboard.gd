extends Panel

var leaderboardItem 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	leaderboardItem = preload("res://leaderboardItem.tscn")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout


func loadLeaderboard():
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores().sw_get_scores_complete
	for x in range(1,$VBoxContainer.get_child_count()):
		$VBoxContainer.get_child(x).queue_free()
	
	for i in sw_result.scores:
		var child = leaderboardItem.instantiate()
		child.get_child(0).text = str(i.player_name)
		child.get_child(1).text = str(int(i.score))
		$VBoxContainer.add_child(child)
	$VBoxContainer.get_child(1).queue_free()
