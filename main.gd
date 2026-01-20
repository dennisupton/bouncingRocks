extends Node2D

var ball
var explodeFX
var ante = 1
var dir = 1
var highscore = 0
var leaderboard
var username
var newHighscore = false
var r = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	highscore = load_highscore_js()
	if highscore > 0:
		$highscore.text = "Highscore : "+ str(highscore)
	username = load_name_js()
	if username:
		$CanvasLayer/Pause/Container/name.text = username
	else:
		username = ""
	ball = preload("res://ball.tscn")
	explodeFX = preload("res://explode.tscn")
	newBall()
	await SilentWolf.configure({
	"api_key": "WebGmID3T96usw6qOoxgt1wW33AUt88R4mgmaLRb",
	"game_id": "baller",
	"log_level": 0
	})

	await SilentWolf.configure_scores({
	"open_scene_on_close": "res://main.tscn"
	})
	$CanvasLayer/Leaderboard.loadLeaderboard()
	#SilentWolf.Scores.wipe_leaderboard()
var score = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$CanvasLayer/bar/remember.visible = username == ""
	if empty():
		dir *= -1
		ante *= 2
		newBall()
	if (Input.is_action_just_pressed("leaderboard") or Input.is_action_just_pressed("shoot")) and $CanvasLayer/Leaderboard.visible:
		$CanvasLayer/Leaderboard.hide()
		Engine.time_scale = 1
	elif Input.is_action_just_pressed("leaderboard"):
		_on_show_leaderboard_pressed()
	
	if Input.is_action_just_pressed("Pause"):
		_on_pause_pressed()
func restart():
	ante = 1
	var lastScore = score
	score = 0
	$score.text = str(score)
	for i in get_children():
		if i.is_in_group("ball"):
			i.queue_free()
	newBall()
	$Player.restarting = false
	var sw_result = await SilentWolf.Scores.get_scores_by_player(username).sw_get_player_scores_complete
	if (not username == "") and lastScore > 35 and (sw_result.scores.size() == 0 or lastScore > sw_result.scores[0].score):
		print("Uploading to Leaderboard")
		$CanvasLayer/saving.show()
		await SilentWolf.Scores.save_score(username, lastScore)
		$CanvasLayer/saving.hide()
		newHighscore = false


func addExplode(pos,color):
	var child = explodeFX.instantiate()
	child.position = pos
	child.color = color
	add_child(child)

func addToScore():
	score += 1
	$score.text = str(score)
	if score > highscore:
		save_highscore_js(score)
		highscore = score
		newHighscore = true
		$highscore.text = "Highscore : "+ str(highscore)
	elif highscore > 0:
		$highscore.text = "Highscore : "+ str(highscore)

func empty():
	for i in get_children():
		if i.is_in_group("ball"):
			return false
	return true


func newBall():
	var child = ball.instantiate()
	child.startHealth = ante
	child.velocity.x = -200 * dir
	child.position = Vector2(r.randi_range(200,970),94)
	#child.scale = Vector2(log(ante+2)/log(10),log(ante+2)/log(10))
	child.wait = true
	add_child(child)

func save_highscore_js(s: int):
	if OS.has_feature("web"):
		JavaScriptBridge.eval(
			"localStorage.setItem('highscore', '%d');" % s
		)
	else:
		$highscore.hide()

func load_highscore_js() -> int:
	if OS.has_feature("web"):
		var result = JavaScriptBridge.eval(
			"localStorage.getItem('highscore');"
		)
		if result != null:
			return int(result)
		print("load highscore result : "+str(result))
	else:
		$highscore.hide()
	save_highscore_js(0)
	return 0


func _on_show_leaderboard_pressed():
	if not $CanvasLayer/Pause.visible:
		$CanvasLayer/Leaderboard.loadLeaderboard()
		Engine.time_scale = 0
		$CanvasLayer/Leaderboard.show()

func _on_pause_pressed() -> void:
	if not $CanvasLayer/Leaderboard.visible:
		$CanvasLayer/Pause/Container/username/name.text = username
		$CanvasLayer/Pause.visible = not $CanvasLayer/Pause.visible
		if $CanvasLayer/Pause.visible:
			Engine.time_scale = 0
		else:
			Engine.time_scale = 1




func save_name_js(s):
	if OS.has_feature("web"):
		JavaScriptBridge.eval(
			"localStorage.setItem('name', '%s');" % s
		
)

func load_name_js():
	if OS.has_feature("web"):
		var result = JavaScriptBridge.eval(
			"localStorage.getItem('name');"
		)
		if result != null:
			return result
		print("load name result : "+result)
	return ""
	


func _on_enter_name_pressed() -> void:
	print("new username")
	username = $CanvasLayer/Pause/Container/username/name.text
	save_name_js(username)
