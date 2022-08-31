extends KinematicBody2D

var waiting
var bullet
var player
var type

var rng = RandomNumberGenerator.new()

var can_shoot

signal enemy_hit

func _ready():
	bullet = load("res://Projectiles/EnemyBullet.tscn")
	waiting = false
	can_shoot = false
	rng.randomize()

func hit():
	queue_free()
	emit_signal("enemy_hit", type)

func enemy_wait():
	waiting = true

func enemy_resume():
	waiting = false

func clear():
	queue_free()

func _on_ShootWaitTimer_timeout():
	can_shoot = true
	$ShootWaitTimer.wait_time = rng.randf_range(0.8, 1.2)
