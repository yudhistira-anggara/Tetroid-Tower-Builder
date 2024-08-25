extends Node2D

@export var left_position: Node2D
@export var right_position: Node2D
@export var crane_pinner: PinJoint2D
@export var respawn_timer: Timer

@onready var tetroid_preload = preload("res://Scenes/tetroid.tscn")

var attached_tetroid
var is_tetroid_attached = false
var tetroids = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_tetroids()
	var tetroid = Tetroid.new()
	tetroid.Placed.connect(spawn_tetroids)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	attach_tetroid()

func _unhandled_input(event):
	drop_action(event)

func attach_tetroid():
	if not is_tetroid_attached: return
	var reached = attached_tetroid.global_position.distance_to(crane_pinner.global_position)
	if reached > 15: return
	crane_pinner.node_b = attached_tetroid.get_path()

func drop_action(event):
	if not event.is_action_pressed("dropped"): return
	is_tetroid_attached = false
	for key in tetroids:
		var tetroid = tetroids[key]
		tetroid.gravity_scale = 1
		tetroid.lock_rotation = false
	crane_pinner.node_b = ""

func tetroid_loader(spawn_position: Vector2, key: String, call_to_deffered):
	var tetroid = tetroid_preload.instantiate()
	tetroid.gravity_scale = 0
	add_child(tetroid) if not call_to_deffered else call_deferred("add_child", tetroid)
	tetroid.global_position = spawn_position
	tetroids[key] = tetroid

func spawn_tetroids(is_called_deffered: bool = false):
	tetroid_loader(left_position.global_position, "left", is_called_deffered)
	tetroid_loader(right_position.global_position, "right", is_called_deffered)

func _on_hook_area_body_entered(body):
	if not body is Tetroid and not is_tetroid_attached: return
	is_tetroid_attached = true
	attached_tetroid = body


func _on_despawn_area_body_exited(body):
	print("body exited")
	if not body is Tetroid and not respawn_timer.is_stopped(): return
	body.queue_free()
	spawn_tetroids(true)
