extends Node
class_name AgentInput

var error: float

var performance_quality: float = .5

var performance_rating: float

var standing_threshold: float = .7

var is_standing: bool = false

# Social_Pressure=(1−neighbour_weight)×Funnel_Pressure+neighbour_weight×Neighbour_Pressure

var social_pressure: float

var neighbor_weight: float = .5

var funnel_pressure: float

var neighbor_pressure: float

# maximum distance from performer. 
## Entered manually for now ##
var max_performer_distance: float = 19.0

# weight to adjust proximity from performer impact
var proximity_weight: float

var green: Material = preload("res://agent/green_mat.tres")
var red: Material = preload("res://agent/red_mat.tres")


func calc_performer_influence(performer_distance):
	#var peformer_distance: float = distance_to_performer()
	var proximity: float = 1.0 - performer_distance/max_performer_distance
	return proximity * proximity_weight


func distance_to_performer(obj, performer):
	return obj.global_transform.origin.distance_to(performer.global_transform.origin)


func calculate_proximity_weight():
	proximity_weight = randf_range(0.5, 0.9)
	#print("proximity weight: " + str(proximity_weight))
	
func calculate_error():
	error = randf_range(-.1, .1)
	#print(error)

func calculate_performance_rating(performer_influence):
	performance_rating = performance_quality + error + performer_influence
	#print(performance_rating)

func agent_response():
	if performance_rating >= standing_threshold:
		is_standing = true
		#print(is_standing)

func calculate_neighbor_pressure():
	neighbor_weight = randf_range(.01, .2)

func set_color(mesh):
	if is_standing == true:
		mesh.set_surface_override_material(0, green)
	else:
		mesh.set_surface_override_material(0, red)



#func calculate
