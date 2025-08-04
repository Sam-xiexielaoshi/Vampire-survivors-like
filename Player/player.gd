extends CharacterBody2D


var movement_speed = 40.0 #basic speed added 
var hp = 80
@onready var sprite: Sprite2D = $Sprite2D
@onready var walkTimer: Timer = %walkTimer

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
	
	#


func _on_hurt_box_hurt(damage: Variant) -> void:
	hp-=damage
	print(hp)
