extends CharacterBody3D

@onready var mesh: MeshInstance3D = $MeshInstance3D

var error: float

var performance_quality: float = .5

var performance_rating: float

var standing_threshold: float = .5

var is_standing: bool = false

var green: Material = preload("res://agent/green_mat.tres")
var red: Material = preload("res://agent/red_mat.tres")

func _ready() -> void:
	randomize()
	calculate_error()
	calculate_performance_rating()
	agent_response()
	if is_standing == true:
		mesh.set_surface_override_material(0, green)
	print(mesh.get_active_material(0))


func calculate_error():
	error = randf_range(-.1, .1)
	#print(error)

func calculate_performance_rating():
	performance_rating = performance_quality + error
	#print(performance_rating)

func agent_response():
	if performance_rating >= standing_threshold:
		is_standing = true
		#print(is_standing)