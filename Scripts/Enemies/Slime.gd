extends CharacterBody2D

const SPEED = 150.0
const KNOCKBACK = 100.0

var isAlive: bool = true
var Health: int = 100
var Target: Node2D

@onready var Sprite: AnimatedSprite2D = $Sprite
@onready var healthBar: Node2D = $HealthBar

func _physics_process(delta: float) -> void:
	if Target != null and isAlive:
		var direction = (Target.position - position).normalized()
		position += direction * SPEED * delta
		Sprite.play("Run")
	
	move_and_slide()

func takeDamage(amount: int, attackedPostion: Vector2) -> void:
	Health -= amount
	$SoundEffects/Damage.play()
	healthBar.updateHealth(int(Health))
	
	var knockbackDirection = (position - attackedPostion).normalized()
	var knockbackPosition = position + knockbackDirection * KNOCKBACK
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position",knockbackPosition, 0.5)
	
	if Health <= 0:
		isAlive = false
		$Sprite.play("Death")
		await $Sprite.animation_finished
		$HealthBar.hide()
		$CollisionShape.set_deferred("disabled", true)
		$Detection/Area.set_deferred("disabled", true)
		await get_tree().create_timer(10).timeout
		queue_free()

func _on_detection_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Target = body

func _on_detection_body_exited(body: Node2D) -> void:
	if body.name == "Player" and isAlive:
		Target = null
		Sprite.play("Idle")
