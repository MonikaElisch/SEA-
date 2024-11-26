extends Node3D

var xr_interface: XRInterface

@onready var _player := $XROrigin3D/PlayerBody

var _cam_rotation := 0.0
func _ready() -> void:
	xr_interface= XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR is initialized successful")
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		get_viewport().use_xr = true
	else:
		print("OpenXR nis initialized successful")
	
	
func _physics_process(delta)-> void:
	get_tree().call_group("enemies","update_target_location", _player.global_transform.origin)
