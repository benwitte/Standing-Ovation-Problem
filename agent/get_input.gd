extends Node
class_name GetInput

func _ready() -> void:
	randomize()
	pass
	
#func initial_input() -> AgentInput:
	#var new_input = AgentInput.new()
	#new_input.error = randf_range(-.1, .1)
	#print(new_input.error)
	#new_input.calculate_performance_rating()
	#new_input.agent_response()

func gather_input() -> AgentInput:
	var new_input = AgentInput.new()
	
	new_input.calculate_error()
	new_input.calculate_performance_rating()
	new_input.agent_response()
	
	return new_input
