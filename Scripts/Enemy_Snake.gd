extends KinematicBody2D

const DEAD="Dead"
const WALK="Walk"
var currentAnimation=""

const GRAVITY=10
const MOVEMENT_SPEED=30
const FLOOR=Vector2(0,-1)

var velocity=Vector2()
var direction=-1

var raycastPos=1

var is_dead=false

func _ready():
	ChangeDirection()
	raycastPos=8.16
	print(raycastPos)


func _physics_process(delta):
	if !is_dead:
		HorizontalMovement()
	
func Dead():
	is_dead=true
	velocity=Vector2(0,0);
	currentAnimation=DEAD
	$AnimatedSprite.play(currentAnimation)
	$CollisionShape2D.set_deferred("disabled",true)
	$Timer.start()
	
func HorizontalMovement():
	velocity.x=direction*MOVEMENT_SPEED
	currentAnimation=WALK
	$AnimatedSprite.play(currentAnimation)
	GravityOn()
	velocity=move_and_slide(velocity,FLOOR)

	if is_on_wall():
		ChangeDirection()
	
	if !$RayCast2D.is_colliding():
		ChangeDirection()

	
func GravityOn():
	velocity.y+=GRAVITY

func ChangeDirection():
	direction*=-1
	
	if direction == 1:
		$AnimatedSprite.set_flip_h( false )
		$RayCast2D.position.x=raycastPos
	elif direction == -1:
		$AnimatedSprite.set_flip_h( true )
		$RayCast2D.position.x=-raycastPos
		


func _on_AnimatedSprite_animation_finished():
	if currentAnimation==DEAD:
		$AnimatedSprite.stop()
		$AnimatedSprite.frame=3


func _on_Timer_timeout():
	queue_free()
