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
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores(20).sw_get_scores_complete
	for x in range(1,$VBoxContainer/VBoxContainer.get_child_count()):
		$VBoxContainer/VBoxContainer.get_child(x).queue_free()
	var idx = 1
	for i in sw_result.scores:
		var child = await leaderboardItem.instantiate()
		if len(str(idx)) == 1:
			child.get_child(0).get_child(0).text = "0"+str(idx)
		else:
			child.get_child(0).get_child(0).text = str(idx)
		child.get_child(0).get_child(1).text = str(i.player_name) 
		child.get_child(1).text = str(int(i.score))
		$VBoxContainer/VBoxContainer.add_child(child)
		idx += 1
