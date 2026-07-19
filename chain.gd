extends Node3D

@export var target: Node3D
@export var softness: float = 0.1	# TODO: make this scale automatically in the script

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bones: Array[Node] = get_tree().get_nodes_in_group("IK_bone").filter(func(n:Node): return not n.is_in_group("IK_end"))
	for bone in bones:
		bone.set_meta("direction",bone.global_basis.z)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	chain_alg(self)
	print("========================")
	print((get_child(0) as Node3D).get_meta("direction"))
	print((get_child(0) as Node3D).basis.z)
	print(((get_child(0) as Node3D).get_meta("direction") as Vector3).angle_to((get_child(0) as Node3D).basis.z))


func chain_alg(node: Node3D):
	var end: Node3D = node
	while !end.is_in_group("IK_end"):
		end = end.get_children().filter(func(n): return n.is_in_group("IK_bone"))[0]
	
	if is_equal_enough(end.global_position, target.global_position, 0.01):
		return
		
	var next: Node3D = node.get_children().filter(func(n): return n.is_in_group("IK_bone"))[0]
	var node_to_target: Vector3 = target.global_position - node.global_position
	var node_to_next: Vector3 = next.global_position - node.global_position
	
	var angle_to_target = node_to_next.angle_to(node_to_target)
	var normal: Vector3 = node_to_next.cross(node_to_target).normalized()
	
	var last_bone: bool = next.is_in_group("IK_end")
	
	var pole_direction: Vector3 = node.get_meta("direction")
	var angle_limit: float = (PI/180) * (node.get_meta("angle_range_deg")/2)
	
	#TODO: kind of works, but not really
	if angle_to_target > angle_limit:
		angle_to_target = node.basis.z.angle_to(pole_direction)
	
	if last_bone:
		if normal != Vector3.ZERO:
			node.global_basis = node.global_basis.rotated(normal, angle_to_target)
		return
	
	var next_to_target: Vector3 = target.global_position - next.global_position
	
	if not last_bone: 
		var next2: Node3D = next.get_children().filter(func(n): return n.is_in_group("IK_bone"))[0]
		var next_to_next2: Vector3 = next2.global_position - next.global_position
		if next_to_next2.length() > next_to_target.length(): angle_to_target *= -1
	
	
	if normal != Vector3.ZERO:
		node.global_basis = node.global_basis.rotated(normal, angle_to_target * softness)
	
	if not last_bone: chain_alg(next) # do alg on the rest of the bones
	
		
	#if is_equal_enough(end.global_position, target.global_position, 0.01):
		#chain_alg(node)

func is_equal_enough(a: Vector3, b: Vector3, margin: float) -> bool:
	return a.distance_squared_to(b) <= (margin * margin)

# dont use, only as an example 
func manual_rotate():
	var aiming_at: Vector3 = global_basis.z.normalized()
	var to_target: Vector3 = (target.global_position - global_position).normalized()
	
	if aiming_at.is_equal_approx(to_target): return
	
	var normal: Vector3 = (aiming_at.cross(to_target)).normalized()
	var angle: float = aiming_at.angle_to(to_target)
		
	global_basis = global_basis.rotated(normal,angle)
