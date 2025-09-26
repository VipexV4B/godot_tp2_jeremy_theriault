extends Node2D

@onready var anim = $CharacterBody2D/Sprite_player

const JUMP_FORCE = -450
const velocity = 

func _process(_delta)
	if Input.is_action_pressed("move_right"):
		anim.play("walk")
	elif Input.is_action_pressed("move_left"):
		anim.play("walk")
	elif Input.is_action_pressed("jump"):
		anim.play("jump")
	elif Input.is_action_pressed("shield"):
		anim.play("shield")
	elif Input.is_action_pressed("shift"):
		anim.play("run")
	else:
		anim.play("idle")
