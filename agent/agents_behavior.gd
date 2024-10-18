extends Node
class_name SocialInput

@onready var agents: SocialInput = $"."

@onready var row_0: Node = $row_0
@onready var row_1: Node = $row_1
@onready var row_2: Node = $row_2
@onready var row_3: Node = $row_3
@onready var row_4: Node = $row_4
@onready var row_5: Node = $row_5


#var row_weight: Array = []

# A nested array of true/false checking who is currently standing in every row
var agents_standing: Array = []

# An array of true/false checking who is currently standing in a row
var row_is_standing: Array = []

# A nested array of 0/.5/1 checking whose neighbors are currently standing in every row
var row_neighbor_pressure: Array = []

# An array of 0/.5/1 checking whose neighbors are currently standing in a row
var agents_neighbor_pressure: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	which_agents_standing()
	#print(agents_standing)
	calc_agents_neighbor_pressure()
	print(agents_neighbor_pressure)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func which_agents_standing():
	for i in agents.get_children():
		for j in i.get_children():
	#		"<StandardMaterial3D#-9223372008618719984>" is identifier for green
			if str(j.get_child(0).get_active_material(0)) == "<StandardMaterial3D#-9223372008618719984>":
				row_is_standing.append(1.0)

			else:
				row_is_standing.append(.0)

			#print(i.get_child(0).get_active_material(0))
		agents_standing.append(row_is_standing)
		row_is_standing = []

func calc_agents_neighbor_pressure():
	for i in agents_standing:
		for j in i.size():
			if j == 0:
				row_neighbor_pressure.append(i[j+1]/2)
			elif j == 8:
				row_neighbor_pressure.append(i[j-1]/2)
			else:
				row_neighbor_pressure.append((i[j+1] + i[j-1])/2)
		agents_neighbor_pressure.append(row_neighbor_pressure)
		row_neighbor_pressure = []

#calculates social pressure from field of view
func calc_funnel_pressure():
	pass
