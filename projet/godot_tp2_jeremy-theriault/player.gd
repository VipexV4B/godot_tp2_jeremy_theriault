extends CharacterBody2D

@onready var anim = $Sprite_player
@onready var animation = $sprite_idle
@onready var ray_left = $RayCastLeft
@onready var ray_right = $RayCastRight

const SPEED = 200.0
const SPEED_RUN = 300.0
const JUMP_FORCE = -330.0
const GRAVITY = 900.0
const WALL_JUMP_FORCE = -300.0
const WALL_PUSHBACK = 420.0   # augmente si tu veux un recul plus visible
const WALL_JUMP_LOCK = 0.18   # durée (s) pendant laquelle on ne réécrit pas velocity.x

var wall_jump_lock_timer := 0.0

func _ready() -> void:
	# s'assurer que les raycasts sont activés
	ray_left.enabled = true
	ray_right.enabled = true

func _physics_process(delta: float) -> void:
	# gravité
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# input horizontal
	var direction := 0.0
	if Input.is_action_pressed("move_right"):
		direction += 1
		anim.flip_h = false
	if Input.is_action_pressed("move_left"):
		direction -= 1
		anim.flip_h = true

	# détection mur via raycast (plus fiable que is_on_wall() parfois)
	var hit_left: bool = false
	var hit_right: bool = false

	hit_left = ray_left.is_colliding()
	hit_right = ray_right.is_colliding()

	# sauts : normal ou wall jump
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_FORCE
		elif (hit_left or hit_right) and not is_on_floor():
			# wall jump : appliquer impulsion verticale + pushback horizontal
			velocity.y = WALL_JUMP_FORCE
			if hit_right:
				velocity.x = -WALL_PUSHBACK
			else:
				velocity.x = WALL_PUSHBACK
			wall_jump_lock_timer = WALL_JUMP_LOCK
			
	# Si timer actif, on ne réécrit PAS velocity.x (laisse le pushback agir)
	if wall_jump_lock_timer > 0.0:
		wall_jump_lock_timer -= delta
	else:
		# contrôle horizontal normal
		if direction == 0:
			velocity.x = 0
		elif Input.is_action_pressed("run"):
			velocity.x = direction * SPEED_RUN
		else:
			velocity.x = direction * SPEED

	# appliquer mouvement (Godot 4 — zero args)
	move_and_slide()

	# animations (optionnel)
	if not is_on_floor():
		anim.show()
		animation.hide()
		if anim.animation != "jump":
			anim.play("jump")
	elif direction == 0 and is_on_floor():
		anim.hide()
		animation.show()
		animation.play("idle")
	elif Input.is_action_pressed("run"):
		anim.show()
		animation.hide()
		anim.play("run")
	else:
		anim.show()
		animation.hide()
		anim.play("walk")
