extends CharacterBody2D


var movement_speed = 40.0 #basic speed added 
var hp = 80
var last_movement = Vector2.UP

var experience =0
var experience_level = 1
var collected_experience = 0

#attack
var iceSpear = preload("res://Player/Attack/ice_spear.tscn")
var tornado = preload("res://Player/Attack/tornado.tscn")
var javelin = preload("res://Player/Attack/javalin.tscn")

#aatack nodes
@onready var iceSpearTimer = get_node("%IceSpearTimer")
@onready var iceSpearAttackTimer = get_node("%IceSpearAttackTimer")
@onready var tornadoTimer = get_node("%TornadoTimer")
@onready var tornadoAttackTimer = get_node("%TornadoAttackTimer")
@onready var sprite: Sprite2D = $Sprite2D
@onready var walkTimer: Timer = %walkTimer
@onready var javelinBase = get_node("%JavelinBase")

#Ice spear
var icespear_ammo = 0
var icespear_baseammo =1
var icespear_attackspeed = 1.5
var icespear_level =0

#Tornado
var tornado_ammo = 0
var tornado_baseammo =1
var tornado_attackspeed = 3
var tornado_level =0

#javelin
var javlin_ammo = 1
var javelin_level = 1

#Enemy related
var enemy_close = []

func _ready() -> void:
	attack()

func _physics_process(delta: float) -> void:#runs on every 60th of the frame i.e 1/60 sec
	movement() #custom function 

func movement(): #function determining the movement direction of the player
	#made a variable x_move determining the movement in x direction by subtracting the action buttons pressed i.e if right and left pressed together then cancel movement etc 
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	#x_mov = 1-0 = 1
	#same logic as above used in x_mov but here in godot the up is negative and down is positive unlike others
	var y_mov = Input.get_action_strength("down")-Input.get_action_strength("up")
	#y_mov =0-0=0
	#defining mov variable to place the character's poisiton on the map using theabove defined functions
	var mov = Vector2(x_mov, y_mov) #mov = Vector2(1x,-y)
	if mov.x > 0:
		sprite.flip_h = true
	elif mov.x<0:
		sprite.flip_h = false
	
	if mov != Vector2.ZERO: #Vector2(0,0)
		last_movement = mov
		if walkTimer.is_stopped():
			if sprite.frame >= sprite.hframes-1:
				sprite.frame = 0
			else:
				sprite.frame+=1
			walkTimer.start()
		
	velocity = mov.normalized()*movement_speed #to make the body move we apply velocity to it 
	#so assuming D is pressed velocity = Vector2(1x,0y)&40 = Vector2(40x, 0y)
	#this means the body rn is moving currently  in +40 pixel/sec with 0 y
	#cause the character to movea
	move_and_slide()

func attack():
	if icespear_level>0:
		iceSpearTimer.wait_time = icespear_attackspeed
		if iceSpearTimer.is_stopped():
			iceSpearTimer.start()
	if tornado_level>0:
		tornadoTimer.wait_time = tornado_attackspeed
		if tornadoTimer.is_stopped():
			tornadoTimer.start()
	if javelin_level>0:
		spawn_javelin()

func _on_hurt_box_hurt(damage, _angle, _knockback: Variant) -> void:
	hp-=damage
	print(hp)


func _on_ice_spear_timer_timeout() -> void:
	icespear_ammo += icespear_baseammo
	iceSpearAttackTimer.start()


func _on_ice_spear_attack_timer_timeout() -> void:
	if icespear_ammo > 0:
		var icespear_attack = iceSpear.instantiate()
		icespear_attack.position = position
		icespear_attack.target = get_random_target()
		icespear_attack.level = icespear_level
		add_child(icespear_attack)
		icespear_ammo -= 1
		if icespear_ammo >0:
			iceSpearAttackTimer.start()
		else:
			iceSpearAttackTimer.stop()

func _on_tornado_timer_timeout() -> void:
	tornado_ammo += tornado_baseammo
	tornadoAttackTimer.start()

func _on_tornado_attack_timer_timeout() -> void:
	if tornado_ammo > 0:
		var tornado_attack = tornado.instantiate()
		tornado_attack.position = position
		tornado_attack.last_movement = last_movement
		tornado_attack.level = tornado_level
		add_child(tornado_attack)
		tornado_ammo -= 1
		if tornado_ammo >0:
			tornadoAttackTimer.start()
		else:
			tornadoAttackTimer.stop()

func spawn_javelin():
	var get_javlin_total = javelinBase.get_child_count()
	var calc_spawns = javlin_ammo-get_javlin_total
	while calc_spawns>0:
		var javelin_spawn = javelin.instantiate()
		javelin_spawn.global_position = global_position
		javelinBase.add_child(javelin_spawn)
		calc_spawns-=1

func get_random_target():
	if enemy_close.size()>0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP


func _on_enemy_detection_area_body_entered(body: Node2D) -> void:
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body: Node2D) -> void:
	if enemy_close.has(body):
		enemy_close.erase(body)
