extends KinematicBody2D

const WALK_ANIMATION="Walk"
const IDLE_ANIMATION="Idle"
const ATTACK_ANIMATION="Attack"
const DIE_ANIMATION="Die"
const FALL_ANIMATION="Fall"
const JUMP_ANIMATION="Jump"

var currentAnimation=""

const MOVEMENT_SPEED=60
var direction=0
var shootDirection=1

const GRAVITY=10
const JUMP_POWER=-250
var is_grounded=false

var is_shooting=false

const FIREBALL=preload("res://Scenes/Hadouken.tscn")

const FLOOR=Vector2(0,-1)

var velocity=Vector2()

func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		if direction==-1 || direction==0:
			direction=1
			ChangeDirection()
	elif Input.is_action_pressed("ui_left"):
		if direction==1 || direction==0:
			direction=-1
			ChangeDirection()
	else:
		direction=0
		if !is_shooting:
			currentAnimation=IDLE_ANIMATION
			$AnimatedSprite.play(currentAnimation)
		
	MovePlayerHorizontally();
	
	if Input.is_action_just_pressed("ui_up"):
		if is_grounded:
			MovePlayerJump()
	
	if Input.is_action_just_pressed("ui_focus_next"):
		Shoot()
	
	GravityOn()
	
	velocity = move_and_slide(velocity,FLOOR)		
	
	if is_on_floor():
		is_grounded=true
	else:
		is_grounded=false
		if velocity.y<0:
			currentAnimation=JUMP_ANIMATION
			$AnimatedSprite.play(currentAnimation)
		else:			
			currentAnimation=FALL_ANIMATION
			$AnimatedSprite.play(currentAnimation)
			

func MovePlayerHorizontally():
	velocity.x=(MOVEMENT_SPEED*direction)
	
func GravityOn():
	velocity.y+=GRAVITY
	
func MovePlayerJump():
	velocity.y=JUMP_POWER
	
func ChangeDirection():
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
		currentAnimation=WALK_ANIMATION
		$AnimatedSprite.play(currentAnimation)

func Shoot():
	currentAnimation=ATTACK_ANIMATION
	$AnimatedSprite.play("Attack")
	is_shooting=true
	
func ShootHadouken():
	var fireball=FIREBALL.instance()
	get_parent().add_child(fireball)
	fireball.position=$Position2D.global_position
	fireball.SetDirection(shootDirection)


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.is_playing() and currentAnimation==ATTACK_ANIMATION:
		is_shooting=false
		ShootHadouken()
