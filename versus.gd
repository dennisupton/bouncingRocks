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
	ball = preload("res://ball.tscn")
	explodeFX = preload("res://explode.tscn")
	newBall()

	#SilentWolf.Scores.wipe_leaderboard()
var score = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if empty() and !$Player.freeze:
		dir *= -1
		ante *= 2
		newBall()
	
	if Input.is_action_just_pressed("Pause"):
		_on_pause_pressed()

func restart():
	for i in get_children():
		if i.is_in_group("ball"):
			i.queue_free()
	ante = 1
	score = 0

	newBall()
	$Player.restarting = false



func addExplode(pos,color):
	var child = explodeFX.instantiate()
	child.position = pos
	child.color = color
	add_child(child)

func addToScore():
	score += 1
	$score.text = str(score)


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
	var s = getBallScale(ante)
	child.scale = Vector2(s,s)
	#child.scale = Vector2(log(ante+2)/log(10),log(ante+2)/log(10))
	child.wait = true
	add_child(child)



func _on_pause_pressed() -> void:
	if not $CanvasLayer/Leaderboard.visible:
		$CanvasLayer/Pause/Container/username/name.text = username
		$CanvasLayer/Pause.visible = not $CanvasLayer/Pause.visible
		if $CanvasLayer/Pause.visible:
			Engine.time_scale = 0
		else:
			Engine.time_scale = 1



func getBallScale(x):
	return (29*x - (26**(2/1.9) * x)**(1.9/2)) / (10*x - (5**(2/1.9) * x)**(1.9/2))
