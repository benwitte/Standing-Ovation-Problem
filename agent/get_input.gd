extends Node
class_name GetInput

@onready var mesh: MeshInstance3D = $"../MeshInstance3D"


func _ready() -> void:
	randomize()
	pass
	



func gather_input() -> AgentInput:
	var new_input = AgentInput.new()
	
	var performer = get_tree().get_first_node_in_group("Performer")
	
	
	new_input.calculate_proximity_weight()
	
	var performer_distance = new_input.distance_to_performer(self.get_parent(), performer)
	var performer_influence = new_input.calc_performer_influence(performer_distance)
	
	new_input.calculate_error()
	new_input.calculate_performance_rating(performer_influence)
	new_input.agent_response()
	new_input.set_color(mesh)
	print("performer influence: " + str(performer_influence))
	print("rating: " + str(new_input.performance_rating))
	print("standing? " + str(new_input.is_standing))

#var activacte_decay = func decay():
	#new_input.performance_rating -= new_input.decay_rate


	return new_input
