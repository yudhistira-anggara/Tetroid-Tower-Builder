extends RigidBody2D
class_name Tetroid

@export var sprite: Sprite2D
const PATH = "res://Assets/Tetrominoes/"
var textures = []

signal Placed

# Called when the node enters the scene tree for the first time.
func _ready():
	textures_loader()
	tetroid_randomizer(textures)
	collision_generator()
	#lock_rotation = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func textures_loader():
	var dir = DirAccess.open(PATH)
	for filename in dir.get_files():
		if filename.contains("import"): continue
		var filepath = PATH + filename
		textures.append(filepath)

func tetroid_randomizer(from:Array):
	var random_index = randi_range(0, from.size() - 1)
	sprite.texture = load(textures[random_index])
	rotation_degrees = 90 * randi_range(-2, 2)
	
func collision_generator():
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(sprite.texture.get_image())
	var polys = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, sprite.texture.get_size()), 5)
	
	for poly in polys:
		var collision_polygon = CollisionPolygon2D.new()
		collision_polygon.polygon = poly
		add_child(collision_polygon)

		# Generated polygon will not take into account the half-width and half-height offset
		# of the image when "centered" is on. So move it backwards by this amount so it lines up.
		if sprite.centered:
			collision_polygon.position -= Vector2(bitmap.get_size()/2)

func _on_body_entered(body):
	print("body collide")
	if not body is Tetroid or not body is StaticBody2D: return
	print("body is either another tetroid or a floor")
	Placed.emit()
	lock_rotation = false
