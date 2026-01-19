extends Node2D

var ball
var ante = 1
var dir = 1
var highscore = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	highscore = load_highscore_js()
	if highscore > 0:
		$highscore.text = "Highscore : "+ str(highscore)
	ball = preload("res://ball.tscn")
	newBall()
	
var score = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if empty():
		dir *= -1
		ante *= 2
		newBall()



func addToScore():
	score += 1
	$score.text = str(score)
	if score > highscore:
		save_highscore_js(score)
		highscore = score
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
	child.position = Vector2(574,94)
	child.scale = Vector2(log(ante+2)/log(10),log(ante+2)/log(10))
	child.wait = true
	add_child(child)

func save_highscore_js(s: int):
	if OS.has_feature("web"):
		JavaScriptBridge.eval(
			"localStorage.setItem('highscore', '%d');" % s
		)
	else:
		print("save failed")
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
