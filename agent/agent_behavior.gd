extends CharacterBody3D

@onready var input: GetInput = $input
@onready var agent: CharacterBody3D = $"."
@onready var mesh: MeshInstance3D = $MeshInstance3D

@onready var vision_cast: RayCast3D = $fov/vision_cast

@onready var timer: Timer = $Timer

@onready var collision_polygon_3d: CollisionPolygon3D = $fov/CollisionPolygon3D
@onready var mesh_instance_3d: MeshInstance3D = $fov/CollisionPolygon3D/MeshInstance3D


var agents_in_sight: Array = []

var agents_array_of_dicts: Array

var visible_agents: Array

# length of field of view of the CollisionPolygon3D
var fov_distance: float = 12.0

# maximum distance any agent in range can be
var max_distance: float

#var agent_dict: Dictionary


var green: Material = preload("res://agent/green_mat.tres")
var red: Material = preload("res://agent/red_mat.tres")

var j = 0
var funnel_input: Array

func _ready() -> void:
	var agent_input = input.gather_input()
	
	if agent_input.is_standing == true:
		mesh.set_surface_override_material(0, green)
	
	# set max distance - doing this manually, so will need to change if I change
	# the size of the CollisionPolygon3D
	# pythag theorum to get furthest distance
	max_distance = sqrt(18**2 + 12**2)

	timer.start()

func _process(delta: float) -> void:
	await get_tree().process_frame
	which_agents_standing()
	while j < 1:
		print("Agents array of dicts: ")
		print(agents_array_of_dicts)
		j+=1
	pass # Replace with function body.


func _on_fov_body_entered(body: CharacterBody3D) -> void:
	agents_in_sight.append(body)
	pass # Replace with function body.
	
	

func which_agents_standing():
	for i in agents_in_sight:
		var temp: Dictionary = create_dict(i)
		#temp.funnel_weight = funnel_influence(float(temp.distance))
		#print("distance type: " + str(typeof(temp.distance)))
		#print("max_distance type: " + str(typeof(max_distance)))
		#print("temp funnel_weight type: " + str(typeof(temp.funnel_weight)))

		agents_array_of_dicts.append(temp)
	#		"<StandardMaterial3D#-9223372008987818739>" is identifier for green in tiny test arena
		#if str(i.get_child(0).get_active_material(0)) == "<StandardMaterial3D#-9223372008987818739>":
			#funnel_input.append(1.0)
#
		#else:
			#funnel_input.append(.0)

func create_dict(body):
	var temp_distance: float = self.global_transform.origin.distance_to(body.global_transform.origin)
	var agent_dict: Dictionary = {"agent": body, 
	"global_position": body.global_position, 
	"is_standing": body.is_standing,
	"distance": temp_distance,
	"visibility": 0,
	"funnel_weight": funnel_influence(temp_distance)}
		#self.global_transform.origin.distance_to(body.global_transform.origin)/max_distance}
	return agent_dict

func visibility_list():
	if vision_cast.is_colliding():
		visible_agents.append(vision_cast.get_collider())
	print(visible_agents) 
	
# update standing function, so we don't have to grab
# distance and body each time
func update_standing():
	for i in agents_array_of_dicts:
		i.is_standing = i.agent.is_standing

func _on_timer_timeout() -> void:
	update_standing() 

func funnel_influence(distance):
	var funnel_weight: float = 0.01 + (1.0-.01) * (1.0 - (distance -2.0)/(max_distance - 2.0))
	return funnel_weight


## Function to check line of sight
#func check_visibility():
	#for i in agents_in_sight:
		#if i == vision_cast.get_collider():
			#print("hi")
	#var start_position = global_transform.origin
	#var target_position = target.global_transform.origin
#
	## Set up the raycast
	#vision_cast.origin = start_position
	#vision_cast.target_position = target_position
#
	#vision_cast.force_raycast_update() # Update the raycast
#
	#if vision_cast.is_colliding():
		#var collider = vision_cast.get_collider()
		#if collider == target:
			#print(target.name + " is visible to " + name)
		#else:
			#print(target.name + " is not visible (obstructed by " + collider.name + ")")
	#else:
		#print(target.name + " is visible to " + name)
