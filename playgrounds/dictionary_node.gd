extends Node
class_name Agent_Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#for i in self.get_children():
		#agents_dict["node"] = i
		#agents_dict["postion"] = i.global_position
		#agents_dict["standing"] = i.is_standing
	#print(agents_dict)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_simple_agent_standing_signal() -> void:
	print("got signal")
	pass # Replace with function body.
