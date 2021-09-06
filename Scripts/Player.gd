extends KinematicBody2D

#Animation names
const WALK_ANIMATION="Walk"
const IDLE_ANIMATION="Idle"
const ATTACK_ANIMATION="Attack"
const DIE_ANIMATION="Die"
const FALL_ANIMATION="Fall"
const JUMP_ANIMATION="Jump"

#var currentAnimation=""

#Movement Properties
const MOVEMENT_SPEED=60
var direction=0
var shootDirection=1

#Jump Properties
const GRAVITY=10
const JUMP_POWER=-250
var is_grounded=false

#Shoot Properties
var is_shooting=false
const FIREBALL=preload("res://Scenes/Hadouken.tscn")

const FLOOR=Vector2(0,-1)
var velocity=Vector2()


func _physics_process(delta):
	MovePlayerHorizontally_Input();
	
	
	MovePlayerJump_Input()
	
	Shoot_Input()
		
	GravityOn()
	
	IsGrounded()
	
	velocity = move_and_slide(velocity,FLOOR)

func MovePlayerHorizontally_Input():
	if Input.is_action_pressed("ui_right"):
		if !is_shooting or !is_on_floor():
			if direction==-1 || direction==0:
				direction=1
				ChangeDirection()
	elif Input.is_action_pressed("ui_left"):
		if !is_shooting or !is_on_floor():
			if direction==1 || direction==0:
				direction=-1
				ChangeDirection()
	else:
		direction=0
		if !is_shooting and is_grounded:
#			currentAnimation=IDLE_ANIMATION
			$AnimatedSprite.play(IDLE_ANIMATION)
	
	velocity.x=(MOVEMENT_SPEED*direction)
	
func GravityOn():
	velocity.y+=GRAVITY
	
func MovePlayerJump_Input():
	if Input.is_action_just_pressed("ui_up"):
		if !is_shooting:
			if is_grounded:
				velocity.y=JUMP_POWER
				is_grounded=false
	
func ChangeDirection():
	if !is_shooting:
		if direction == 1:
			$AnimatedSprite.set_flip_h( false )
			shootDirection=direction
			if sign($Position2D.position.x)==-1:
				$Position2D.position.x*=-1
		elif direction == -1:
			$AnimatedSprite.set_flip_h( true )
			shootDirection=direction
			if sign($Position2D.position.x)==1:
				$Position2D.position.x*=-1
	if is_grounded:
#		currentAnimation=WALK_ANIMATION
		$AnimatedSprite.play(WALK_ANIMATION)

func Shoot_Input():
	if Input.is_action_just_pressed("ui_focus_next") and !is_shooting:
		if is_on_floor():
			velocity.x=0
		is_shooting=true
	#	currentAnimation=ATTACK_ANIMATION
		$AnimatedSprite.play(ATTACK_ANIMATION)
		ShootHadouken()

func ShootHadouken():
	var fireball=FIREBALL.instance()
	get_parent().add_child(fireball)
	fireball.position=$Position2D.global_position
	fireball.SetDirection(shootDirection)

func IsGrounded():
	if is_on_floor():
		if !is_grounded:
			is_shooting=false
		is_grounded=true
	else:
		if !is_shooting:
			is_grounded=false
			if velocity.y<0:
#				currentAnimation=JUMP_ANIMATION
				$AnimatedSprite.play(JUMP_ANIMATION)
			else:			
#				currentAnimation=FALL_ANIMATION
				$AnimatedSprite.play(FALL_ANIMATION)


func _on_AnimatedSprite_animation_finished():
#	if $AnimatedSprite.is_playing() and currentAnimation==ATTACK_ANIMATION:
#	if $AnimatedSprite.is_playing():
		is_shooting=false
#		ShootHadouken()
