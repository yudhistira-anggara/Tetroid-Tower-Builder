extends Node2D

@onready var tetroid_loader = preload("res://Scenes/tetroid.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var tetroid: Tetroid = tetroid_loader.instantiate()
	add_child(tetroid)
	tetroid.position = Vector2(0, 400)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
