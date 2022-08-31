extends KinematicBody2D

var velocity
var movespeed = 400
var bullet
var canfire:bool
var paused:bool

signal player_hit

# Called when the node enters the scene tree for the first time.
func _ready():
	bullet = load("res://Projectiles/Bullet.tscn")
	canfire = true
	paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	# Process movement
	var dir_move = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = movespeed * dir_move
	move_and_slide(velocity)
	
	# Process turning
	var dir_turn = Input.get_vector("turn_left", "turn_right", "turn_up", "turn_down")
	if dir_turn.length() != 0:
		self.rotation = dir_turn.angle()
	elif dir_move.length() != 0:
		self.rotation = dir_move.angle()
	
	# Fire bullets
	var shooting = Input.get_action_strength("fire")
	if shooting > 0.5 and canfire and not paused:
		var instance = bullet.instance()
		instance.rotation = self.rotation
		instance.position = self.position
		get_parent().add_child(instance)
		canfire = false
		$CooldownTimer.start()
		$AudioStreamPlayer.play()

func _on_CooldownTimer_timeout():
	canfire = true

func hit():
	emit_signal("player_hit")
	$CollisionPolygon2D.set_deferred("disabled", true)
	self.modulate.a = 0.2
	
func respawn():
	get_node("CollisionPolygon2D").disabled = false 
	paused = false
	self.modulate.a = 1.0
	
