extends CharacterBody2D

const SPEED = 300.0

var lastDirection: Vector2 = Vector2.RIGHT
var isAttacking: bool = false
var hitboxOffset: Vector2
var Damage: int = 20

@onready var Sprite: AnimatedSprite2D = $Sprite
@onready var Hitbox: Area2D = $Hitbox

func _ready() -> void:
	hitboxOffset = Hitbox.position

func _physics_process(_delta: float) -> void:
	Hitbox.monitoring = false
	
	if Input.is_action_just_pressed("Attack"):
		Attack()
	
	processMovement()
	processPlayerAnimation()
	move_and_slide()

func processMovement():
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	
	if direction != Vector2.ZERO and not isAttacking:
		velocity = direction * SPEED
		lastDirection = direction
		updateHitboxOffset()
	else:
		velocity = Vector2.ZERO

func processPlayerAnimation() -> void:
	if isAttacking:
		playPlayerAnimation("Attack", lastDirection)
		await Sprite.animation_finished
		isAttacking = false
	if velocity != Vector2.ZERO:
		playPlayerAnimation("Run", lastDirection)
	else:
		playPlayerAnimation("Idle", lastDirection)

func playPlayerAnimation(prefix: String, direction: Vector2) -> void:
	if direction.x != 0:
		Sprite.flip_h = direction.x < 0
		Sprite.play(prefix + "Right")
	elif direction.y < 0:
		Sprite.play(prefix + "Up")
	elif direction.y > 0:
		Sprite.play(prefix + "Down")

func Attack() -> void:
	isAttacking = true
	Hitbox.monitoring = true
	$SoundEffects/SwordSwinging.play()

func updateHitboxOffset() -> void:
	var x := hitboxOffset.x
	var y := hitboxOffset.y
	
	match lastDirection:
		Vector2.LEFT:
			Hitbox.position = Vector2(-x, y)
		Vector2.RIGHT:
			Hitbox.position = Vector2(x, y)
		Vector2.UP:
			Hitbox.position = Vector2(y, -x)
		Vector2.DOWN:
			Hitbox.position = Vector2(-y, x)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies") and isAttacking:
		body.takeDamage(Damage, position)
