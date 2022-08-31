extends KinematicBody2D

var movespeed = 800
var direction

# Called when the node enters the scene tree for the first time.
func _ready():
	direction = Vector2(cos(self.rotation), sin(self.rotation))

func _physics_process(delta):
	var collision = move_and_collide(direction * movespeed * delta)
	
	if collision:
		collision.collider.hit() #tell whatever we hit that it's been hit
		queue_free()


func _on_Timer_timeout():
	queue_free()

func hit():
	queue_free()

