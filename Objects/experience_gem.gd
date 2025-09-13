extends Area2D

@export var experience = 1

var spr_green = preload("res://Texture/Items/Gems/Gem_green.png")
var spr_blue = preload("res://Texture/Items/Gems/Gem_blue.png")
var spr_red = preload("res://Texture/Items/Gems/Gem_red.png")

var target = null
var speed = -1

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var sound = $snd_collected

func _ready() -> void:
	if experience < 5:
		return
	elif experience<25:
		sprite.texture = spr_blue
	else:
		sprite.texture = spr_red
	# Start invisible & small
	scale = Vector2(0.2, 0.2)
	sprite.modulate.a = 0.0  # alpha 0 = invisible

	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(sprite, "modulate:a", 1.0, 0.3)

func _physics_process(delta: float) -> void:
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed+=2*delta
		
func collect():
	sound.play()
	collision.call_deferred("set", "disabled", true)
	sprite.visible =false
	return experience

func _on_snd_collected_finished() -> void:
	queue_free()
