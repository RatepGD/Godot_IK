extends Node3D

@export var target: Node3D
@export var step_radius: float = 0.5
@onready var raycast: RayCast3D = self.get_children().filter(func(n): return n.is_class("RayCast3D"))[0]

var ready_to_step: bool = false
var _stepping: bool = false
var _t: float = false
var _target_start: Vector3
var _target_end: Vector3

func _process(delta: float) -> void:
	
	var distance:float = target.global_position.distance_to(raycast.get_collision_point())
	if distance >= step_radius and not _stepping: #maybe check raycast.is_colliding()
		ready_to_step = true
		_target_end = raycast.get_collision_point()
		do_step()

	if _stepping:
		var pos: Vector3 = _target_start.lerp(_target_end, _t)
		
		#if _t < 0.5 and pos.y < _target_end.y:
		var y = sin((_t * PI) * distance) + _target_end.y
		pos.y = y
		
		target.global_position = pos
		
		print(y)
		_t += delta
		if _t >= 1:
			_stepping = false
			ready_to_step = false
			_t = 0

func do_step():
	print("step")
	_stepping = true
	_target_start = target.global_position
	#print(_target_start,_target_end)
