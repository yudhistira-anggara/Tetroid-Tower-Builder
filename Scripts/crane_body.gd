extends CharacterBody2D
class_name CraneBody

@export var speed = 300.0

func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed * delta
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()
