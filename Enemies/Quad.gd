extends "res://Enemies/Enemy.gd"

var movespeed = 10

func _ready():
	type = "quad"

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
		var b1 = bullet.instance()
		var b2 = bullet.instance()
		var b3 = bullet.instance()
		var b4 = bullet.instance()
		b1.position = self.position
		b2.position = self.position
		b3.position = self.position
		b4.position = self.position
		b1.rotation = self.rotation
		b2.rotation = self.rotation + (90 * PI/180)
		b3.rotation = self.rotation + (180 * PI/180)
		b4.rotation = self.rotation + (270 * PI/180)
		get_parent().add_child(b1)
		get_parent().add_child(b2)
		get_parent().add_child(b3)
		get_parent().add_child(b4)
		$AudioStreamPlayer.play()
