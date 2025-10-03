extends CharacterBody2D

@onready var anim = $Sprite_player
@onready var animation = $sprite_idle

const SPEED = 200.0
const SPEED_RUN = 300.0
const JUMP_FORCE = -330.0
const GRAVITY = 900.0

func _physics_process(delta: float) -> void:
	# gravité
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	var direction := 0.0

	# Déplacements horizontaux
	if Input.is_action_pressed("move_right"):
		direction += 1
		anim.flip_h = false
	if Input.is_action_pressed("move_left"):
		direction -= 1
		anim.flip_h = true

	velocity.x = direction * SPEED

	# Saut
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_FORCE

	# Déplacement
	move_and_slide()

	# Animations
	if not is_on_floor():
		anim.show()
		animation.hide()
		if anim.animation != "jump":
			anim.play("jump")

	elif direction == 0 and is_on_floor():
		anim.hide()
		animation.show()
		animation.play("idle")

	else:
		anim.show()
		animation.hide()
		anim.play("walk")
