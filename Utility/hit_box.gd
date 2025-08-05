extends Area2D

@export var damage = 1
@onready var collision = $CollisionShape2D
@onready var diableTimer = $DiableHitBoxTimer

func tempdisable():
	collision.call_deferred("set", "disabled", true)
	diableTimer.start()

func _on_diable_hit_box_timer_timeout() -> void:
	collision.call_deferred("set", "disabled", false)
