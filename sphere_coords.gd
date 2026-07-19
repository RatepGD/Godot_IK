extends Node3D

@export_range(0,2*PI) var theta: float
@export_range(0,2*PI) var fi: float
@export var radius: float

func _ready() -> void:
	print("ahoj svete")

func _process(delta: float) -> void:
	var translated_pose = Vector3(
		radius*cos(fi)*cos(theta),	# X
		radius*sin(fi)*cos(theta),	# Y
		radius*sin(theta))			# Z
	position = translated_pose
	print(position)
