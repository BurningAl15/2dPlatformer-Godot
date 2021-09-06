extends Area2D

const SPEED=100
var velocity=Vector2()
var direction=0

func _ready():
	pass # Replace with function body.


func _process(delta):
	velocity.x=SPEED*delta*direction
	translate(velocity)
	$AnimatedSprite.play("shoot")

	
func SetDirection(var _direction):
	direction=_direction
	ChangeDirection()
	
func ChangeDirection():
	if direction == 1:
		$AnimatedSprite.set_flip_h( false )
	elif direction == -1:
		$AnimatedSprite.set_flip_h( true )

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Hadouken_body_entered(body):
	if "Enemy" in body.name:
		body.Dead()
	queue_free()
