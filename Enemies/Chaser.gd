extends "res://Enemies/Enemy.gd"

var movespeed = 100

func _ready():
	type = "chaser"

func _physics_process(delta):
	if waiting:
		return
	
	if player:
		var direction = (player.get_transform().origin 
			- self.get_transform().origin).normalized()
		var collision = move_and_collide(movespeed * direction * delta)
		self.rotation = direction.angle()
		if collision and collision.collider.name == "Player":
			collision.collider.hit()


func _on_FireTimer_timeout():
	if not waiting and can_shoot:
		var instance = bullet.instance()
		instance.rotation = self.rotation
		instance.position = self.position
		get_parent().add_child(instance)
		$AudioStreamPlayer.play()


