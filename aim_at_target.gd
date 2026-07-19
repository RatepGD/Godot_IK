extends Node3D

@export var target: Node3D
@export_range(0,180) var rotation_limit_degrees: float = 180
var rotation_limit: float

func _ready() -> void:
	rotation_limit = (PI/180) * rotation_limit_degrees

func _process(_delta: float) -> void:
	manual_rotate()


func manual_rotate():
	var aiming_at: Vector3 = global_basis.z.normalized()
	var to_target: Vector3 = (target.global_position - global_position).normalized()
	
	if aiming_at.is_equal_approx(to_target): return
	
	var normal: Vector3 = (aiming_at.cross(to_target)).normalized()
	var angle: float = aiming_at.angle_to(to_target)
		
	global_basis = global_basis.rotated(normal,angle)


func ez_rotate():
	var target_vector = global_position.direction_to(target.global_position)
	var target_basis = Basis.looking_at(target_vector,Vector3.UP,true)
	basis = target_basis
