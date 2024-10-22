extends CharacterBody3D

@onready var input: GetInput = $input
@onready var agent: CharacterBody3D = $"."
@onready var mesh: MeshInstance3D = $MeshInstance3D

@onready var vision_cast: RayCast3D = $fov/vision_cast

var players_in_sight: Array = []

#var red = Color.hex(0xff0000ff)
#var green = Color.hex(0x00ff00ff)
var green: Material = preload("res://agent/green_mat.tres")
var red: Material = preload("res://agent/red_mat.tres")

var j = 0
var funnel_input: Array
#func _physics_process(_delta: float) -> void:

func _ready() -> void:
	var agent_input = input.gather_input()
	
	if agent_input.is_standing == true:
		mesh.set_surface_override_material(0, green)

func _process(delta: float) -> void:
	#which_agents_standing()
	await get_tree().process_frame
	while j < 1:
		#print(funnel_input)
		j+=1


	#players_in_sight.append(body)
	#for i in players_in_sight:
		#vision_cast.look_at(i.translation, Vector3.UP)
		#if vision_cast.is_colliding():
			#print("seen")
		#
	#print(players_in_sight)
	#var direction = global_position.direction_to(body.global_position)
	#var facing = global_transform.basis.tdotz(direction)
	#var fov = cos(deg_to_rad(70))
	#if facing > fov:
		#print("in view")
	#else:
		#print("Not in view")
	
	#print("object inside")
	pass # Replace with function body.


func _on_fov_body_entered(body: CharacterBody3D) -> void:
	#print(body.get_parent())
	players_in_sight.append(body)
	if body.is_standing == true:
		print("true")
	pass # Replace with function body.
	
	

func which_agents_standing():
	for i in players_in_sight:
		pass
	#		"<StandardMaterial3D#-9223372008987818739>" is identifier for green in tiny test arena
		#if str(i.get_child(0).get_active_material(0)) == "<StandardMaterial3D#-9223372008987818739>":
			#funnel_input.append(1.0)
#
		#else:
			#funnel_input.append(.0)
