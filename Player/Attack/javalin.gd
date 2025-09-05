extends Area2D

var level = 1
var hp = 9999
var speed = 200.0
var damage = 10
var knockback_amount = 100
var paths = 1
var attack_size = 1.0
var attack_speed = 4.0

var target = Vector2.ZERO
var target_array = []

var angle = Vector2.ZERO
var reset_pos = Vector2.ZERO

var spr_jav_reg = preload("res://Texture/Items/Weapons/javelin_3_new.png")
var spr_jav_attack = preload("res://Texture/Items/Weapons/javelin_3_new_attack.png")

@onready var player = get_tree().get_first_node_in_group("player")
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var attackTimer = get_node("%AttackTimer")
@onready var changeDirectionTimer = get_node("%ChangeDirection")
@onready var ResetPosTimer = get_node("%ResetPosTimer")
@onready var snd_attack = $snd_attack

signal remove_from_array(object)

func _ready() -> void:
	update_javelin()
	
func update_javelin():
	level = player.javelin_level
	match  level:
		1:
			hp =9999
			speed = 200.0
			damage = 10
			knockback_amount = 100
			paths = 1
			attack_size = 1.0
			attack_speed = 4.0
	scale  = Vector2(1.0,1.0)+attack_size
	attackTimer.wait_time = attack_speed
	
func _physics_process(delta: float) -> void:
	if target_array.size()>0:
		position+=angle*speed*delta

func _on_attack_timer_timeout() -> void:
	pass # Replace with function body.
