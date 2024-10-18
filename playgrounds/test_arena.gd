extends Node3D

var agent_path := preload("res://agent/agent.tscn")

var agents_array: Array = []
var agents_row: Array = []

var base_position : Vector3 = Vector3(0, 1, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

	
#func inst(pos):
	#var instance = agent_path.instantiate()
	#instance.position = pos
	#add_child(instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
