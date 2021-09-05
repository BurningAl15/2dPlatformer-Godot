extends KinematicBody2D

const MOVEMENT_SPEED=60
var direction=0

const GRAVITY=10
const JUMP_POWER=-250
var is_grounded=false

const FLOOR=Vector2(0,-1)

var velocity=Vector2()

func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		if direction==-1 || direction==0:
			direction=1
			ChangeDirection()
		if is_grounded:
			$AnimatedSprite.play("Walk")
	elif Input.is_action_pressed("ui_left"):
		if direction==1 || direction==0:
			direction=-1
			ChangeDirection()
		if is_grounded:
			$AnimatedSprite.play("Walk")
	else:
		direction=0
		$AnimatedSprite.play("Idle")
		
	MovePlayerHorizontally();
	
	if Input.is_action_just_pressed("ui_up"):
		if is_grounded:
			MovePlayerJump()
	
	GravityOn()
	
	velocity = move_and_slide(velocity,FLOOR)		
	
	if is_on_floor():
		is_grounded=true
	else:
		is_grounded=false
		if velocity.y<0:
			$AnimatedSprite.play("Jump")
		else:			
			$AnimatedSprite.play("Fall")
			

func MovePlayerHorizontally():
	velocity.x=(MOVEMENT_SPEED*direction)
	
func GravityOn():
	velocity.y+=GRAVITY
	
func MovePlayerJump():
	velocity.y=JUMP_POWER
	
func ChangeDirection():
	if direction == 1:
		$AnimatedSprite.set_flip_h( false )
	elif direction == -1:
		$AnimatedSprite.set_flip_h( true )

	
