extends Node
class_name AgentInput

var error: float

var performance_quality: float = .5

var performance_rating: float

var standing_threshold: float = .5

var is_standing: bool = false

# Social_Pressure=(1−neighbour_weight)×Funnel_Pressure+neighbour_weight×Neighbour_Pressure

var social_pressure: float

var neighbor_weight: float = .5

var funnel_pressure: float

var neighbor_pressure: float
	
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

func calculate_neighbor_pressure():
	neighbor_weight = randf_range(.01, .2)

#func calculate
