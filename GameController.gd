extends Node

var rng = RandomNumberGenerator.new()

var score = 0
var lives = 3

# Enemies
var chaser
var trishooter
var quad

func _ready():
	$Player.connect("player_hit", self, "player_hit")
	rng.randomize()
	chaser = load("res://Enemies/Chaser.tscn")
	trishooter = load("res://Enemies/Trishooter.tscn")
	quad = load("res://Enemies/Quad.tscn")
	
func _process(delta):
	$Overlay/Lives.text = "Lives: " + String(lives)
	$Overlay/Score.text = "Score: " + String(score)

func player_hit():
	$Player.paused = true
	lives -= 1
	get_tree().call_group("enemies", "enemy_wait")
	get_tree().call_group("bullets", "queue_free")
	$EnemySpawnTimer.stop()
	if lives > 0:
		$RespawnTimer.start()
	else:
		game_over()

func enemy_hit(type):
	match type:
		"chaser":
			score += 10
		"trishooter":
			score += 30
		"quad":
			score += 40

func game_over():
	$GameOver.popup_centered()
	$EnemySpawnTimer.stop()

func new_game():
	get_tree().call_group("enemies", "clear")
	score = 0
	lives = 3
	$Player.respawn()
	$GameOver.hide()
	$EnemySpawnTimer.start()

func spawn_enemies():
	var instance
	$EnemyPath/EnemySpawnLocation.offset = randi()
	
	# Choose type of enemy to spawn
	var randenemy = rng.randf_range(0.0,1.0)
	if randenemy > .9:
		instance = quad.instance()
	elif randenemy > .8:
		instance = trishooter.instance()
	else:
		instance = chaser.instance()
	instance.connect("enemy_hit", self, "enemy_hit")
	instance.player = $Player
	instance.position = $EnemyPath/EnemySpawnLocation.position
	add_child(instance)

func _on_RespawnTimer_timeout():
	$Player.respawn()
	get_tree().call_group("enemies", "enemy_resume")
	$EnemySpawnTimer.start()


func _on_GameOver_new_game():
	new_game()

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		if not get_tree().paused:
			get_tree().paused = true
			$Settings.popup_centered()
		else:
			get_tree().paused = false
			$Settings.hide()

func _on_EnemySpawnTimer_timeout():
	spawn_enemies()
