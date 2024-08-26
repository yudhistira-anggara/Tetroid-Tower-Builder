extends Node2D

@export var left_position: Node2D
@export var right_position: Node2D
@export var crane_pinner: PinJoint2D
@export var respawn_timer: Timer

@onready var tetroid_preload = preload("res://Scenes/tetroid.tscn")

var attached_tetroid
var is_tetroid_attached = false
var tetroids = {}



func _ready():
	spawn_tetroids()
	var tetroid = Tetroid.new()

func _physics_process(delta):
	pass

func _unhandled_input(event):
	drop_action(event)


func drop_action(event):
	if not event.is_action_pressed("dropped"): return
	if not is_tetroid_attached: return
	is_tetroid_attached = false
	for key in tetroids:
		var tetroid = tetroids[key]
		if not tetroid == attached_tetroid:
			tetroid.queue_free()
	attached_tetroid.gravity_scale = 1
	attached_tetroid.lock_rotation = false
	crane_pinner.node_b = ""
	await get_tree().create_timer(1.50).timeout
	spawn_tetroids()

func tetroid_loader(spawn_position: Vector2, key: String, call_to_deffered):
	var tetroid = tetroid_preload.instantiate()
	tetroid.gravity_scale = 0
	add_child(tetroid) if not call_to_deffered else call_deferred("add_child", tetroid)
	tetroid.modulate = Color("ffffff00")
	create_tween().tween_property(tetroid, "modulate", Color("ffffff"), 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tetroid.global_position = spawn_position
	tetroids[key] = tetroid

func spawn_tetroids(is_called_deffered: bool = false):
	tetroid_loader(left_position.global_position, "left", is_called_deffered)
	tetroid_loader(right_position.global_position, "right", is_called_deffered)

func _on_hook_area_body_entered(body):
	if not body is Tetroid and not is_tetroid_attached: return
	is_tetroid_attached = true
	attached_tetroid = body
	crane_pinner.node_b = attached_tetroid.get_path()

# func _on_despawn_area_body_exited(body):
# 	print("body exited")
# 	if not body is Tetroid and not respawn_timer.is_stopped(): return
# 	body.queue_free()
# 	spawn_tetroids(true)
