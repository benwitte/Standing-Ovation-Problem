extends CharacterBody3D

@onready var input: GetInput = $input
@onready var agent: CharacterBody3D = $"."
@onready var mesh: MeshInstance3D = $MeshInstance3D

@onready var vision_cast: RayCast3D = $fov/vision_cast

@onready var timer: Timer = $Timer

#@onready var neighbors_collision: CollisionShape3D = $neighbors/neighbors_collision
#@onready var neighbors_visual: MeshInstance3D = $neighbors/neighbors_collision/neighbors_visual
#
#@onready var fov_collision: CollisionPolygon3D = $fov/fov_collision
#@onready var fov_visual: MeshInstance3D = $fov/fov_collision/fov_visual

var agents_in_sight: Array = []

var agents_array_of_dicts: Array

var visible_agents: Array


var neighbor_agents: Array = []

var neighbors_array_of_dicts: Array


# length of field of view of the CollisionPolygon3D
var fov_distance: float = 12.0

# maximum distance any agent in funnel influence range
var max_distance: float


var neighbor_weight: float


#var agent_dict: Dictionary


var green: Material = preload("res://agent/green_mat.tres")
var red: Material = preload("res://agent/red_mat.tres")

var j = 0
var funnel_input: Array

@onready var fov: Area3D = $fov

var funnel_pressure: float
var neighbor_pressure: float

var total_stand_pressure: float
var total_sit_pressure: float

var social_pressure_threshold = randf_range(0.2, 0.8)

@onready var agent_input = input.gather_input()

var changed_status: bool

var decay_rate: float = .01

var performance_with_decay: float

var seconds_passed: float = 0

func _ready() -> void:
	neighbor_weight = randf_range(0.3, 0.7)
	
	# set max distance - doing this manually, so will need to change if I change
	# the size of the CollisionPolygon3D
	# pythag theorum to get furthest distance
	max_distance = sqrt(18**2 + 12**2)
	
	performance_with_decay = agent_input.performance_rating
	
	
	await get_tree().process_frame
	which_agents_standing()
	which_neighbors_standing()
	#print("standing? " + str(agent_input.is_standing))

	timer.start()

func _process(_delta: float) -> void:
	
	while j < 1:
		#print("Agents array of dicts: ")
		#print(agents_array_of_dicts)
		#print("Neighbors")
		#print(neighbors_array_of_dicts)
		#funnel_pressure = calc_funnel_pressure()
		#print("funnel_pressure: " + str(funnel_pressure))
		#neighbor_pressure = calc_neighbor_pressure()
		#print("neighbor_pressure: " + str(neighbor_pressure))
		#print("neighbor_weight: " + str(neighbor_weight))
		#total_social_pressure = funnel_pressure + neighbor_weight * neighbor_pressure
		#print("total_social_pressure: " + str(total_social_pressure))
		j+=1
	pass # Replace with function body.

#add_collision_exception_with(agent) 




func _on_fov_body_entered(body) -> void:
	agents_in_sight.append(body)
	pass # Replace with function body.

func _on_neighbors_body_entered(body) -> void:
	if body == self:
		pass
	else:
		neighbor_agents.append(body)
	
	
## FUTURE TO DO:
# the next two functions are the same. they should be refactored 
# so the same function can be used for both situations,
# then that function should be moved to behaviors
func which_neighbors_standing():
	for i in neighbor_agents:
		var temp: Dictionary = create_neighbor_dict(i)
		neighbors_array_of_dicts.append(temp)


func which_agents_standing():
	for i in agents_in_sight:
		var temp: Dictionary = create_dict(i)
		agents_array_of_dicts.append(temp)



## FUTURE TO DO:
# the next two functions are the same. they should be refactored 
# so the same function can be used for both situations,
# then that function should be moved to behaviors
func create_neighbor_dict(body):
	#print(body)
	#print(self)
	var agent_dict: Dictionary = {"agent": body, 
	"global_position": body.global_position, 
	"is_standing": body.agent_input.is_standing}
		#self.global_transform.origin.distance_to(body.global_transform.origin)/max_distance}
	return agent_dict

func create_dict(body):
	var temp_distance: float = self.global_transform.origin.distance_to(body.global_transform.origin)
	var agent_dict: Dictionary = {"agent": body, 
	"global_position": body.global_position, 
	"is_standing": body.agent_input.is_standing,
	"distance": temp_distance,
	"visibility": 0,
	"funnel_weight": funnel_influence(temp_distance)}
		#self.global_transform.origin.distance_to(body.global_transform.origin)/max_distance}
	return agent_dict

#func visibility_list():
	#if vision_cast.is_colliding():
		#visible_agents.append(vision_cast.get_collider())
	#print(visible_agents) 
	
# update standing function, so we don't have to grab
# distance and body each time
func update_standing(array):
	for i in array:
		i.is_standing = i.agent.agent_input.is_standing

func _on_timer_timeout() -> void:
	seconds_passed += 1.0
	if performance_with_decay > 0:
		performance_with_decay = decay(performance_with_decay, seconds_passed)
		update_agent_status()
	

		funnel_pressure = calc_funnel_pressure()
		#print("funnel_pressure: " + str(funnel_pressure))
		neighbor_pressure = calc_neighbor_pressure()
		#print("neighbor_pressure: " + str(neighbor_pressure))
		#print("neighbor_weight: " + str(neighbor_weight))
		if agents_array_of_dicts.size() == 0:
			total_stand_pressure = neighbor_weight * neighbor_pressure + agent_input.performer_influence
		else:
			total_stand_pressure = funnel_pressure + neighbor_weight * neighbor_pressure + agent_input.performer_influence

		total_sit_pressure = 1 - total_stand_pressure
		#print("total_stand_pressure: " + str(total_stand_pressure))
		#print("total_sit_pressure: " + str(total_sit_pressure))
		#print("pressure threshold: " + str(social_pressure_threshold))
		update_standing(agents_array_of_dicts)
		update_standing(neighbors_array_of_dicts)
		#print("performance rating: " + str(performance_with_decay))
	else:
		agent_input.is_standing = false
		


func decay(perf, n):
	return perf - decay_rate * n

# Function to update standing state based on pressures
func update_state():
	if performance_with_decay < 0:
		return false
	else:
		
		# Determine priorities with standard conditionals
		var stand_priority: int = 0
		var sit_priority: int = 0
		var comparison: int = 0
		#var time_decay: int = 1

		if total_stand_pressure > social_pressure_threshold:
			stand_priority = 1
		if total_sit_pressure > social_pressure_threshold:
			sit_priority = 1
		if total_stand_pressure > total_sit_pressure:
			comparison = 1
		
		var match_array: Array = [stand_priority, sit_priority, comparison]

	# Determine the new state
		match match_array:
			[1, 0, _]: return true  # Only stand_pressure above threshold
			[0, 1, _]: return false   # Only sit_pressure above threshold
			[1, 1, 1]: return true   # Both above threshold, stand_pressure > sit_pressure
			[1, 1, 0]: return false   # Both above threshold, sit_pressure > stand_pressure
			_: return agent_input.is_standing  # No change if no conditions met

# if status unchanged, do nothing. If true, stand. If false, sit
func update_agent_status():
	var status_check: bool = update_state()
	if status_check == agent_input.is_standing:
		#print("no change!")
		pass
	elif status_check == true:
		agent_input.is_standing = true
		mesh.set_surface_override_material(0, green)
		#print(true)
	elif status_check == false:
		agent_input.is_standing = false
		mesh.set_surface_override_material(0, red)
		#print(false)


func funnel_influence(distance):
	# 1 - normalized log values creats convex shape that gives closest agents
	# the hightest weight
	# 2 - -1 to each side makes sure that max returned value is 1 
	var funnel_weight: float = 1 - log(distance-1)/log(max_distance-1)
	return funnel_weight
	
func calc_funnel_pressure():
	var temp: float = 0
	if agents_array_of_dicts.size() > 0:
		for i in agents_array_of_dicts:
			temp += int(i.is_standing) * i.funnel_weight
		return temp/agents_array_of_dicts.size()
	else:
		return 0
	
func calc_neighbor_pressure():
	var temp: float = 0
	for i in neighbors_array_of_dicts:
		temp += int(i.is_standing)
	return temp/neighbors_array_of_dicts.size()
	



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
