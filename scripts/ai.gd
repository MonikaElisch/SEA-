extends CharacterBody3D

@onready var nav_agent := $NavigationAgent3D as NavigationAgent3D
#@onready var Target = get_parent().get_node("robot")
@onready var Target = $"../XROrigin3D/PlayerBody"


var speed= 3.0
#func _ready():
	#set_physics_process(false)
	#await get_tree().physics_frame
	#set_physics_process(true)

func  _physics_process(_delta: float) -> void:
	look_at(Target.global_transform.origin, Vector3.UP)
	var current_position = global_transform.origin
	var next_position := nav_agent.get_next_path_position()
	#var new_velocity = (next_position - current_position).normalized() * speed
	#	nav_agent.set_velocity_forced(new_velocity)
	#var offset := next_position - global_transform.origin
	global_position = global_position.move_toward(next_position, _delta * speed)
	#offset.y = 0

func update_target_location(target_location)-> void:
	nav_agent.target_position = target_location

func _on_navigation_agent_3d_target_reached():
	print("in range")

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, .25)
	move_and_slide()

func _on_timer_timeout() -> void:
	var overlaps = $VisionArea.get_overlapping_bodies()
	if overlaps.size() > 0:
		for overlap in overlaps:
			if overlap.name == "XROrigin3D":
				if $VisionRaycast.is_colliding():
					var collider = $VisionRayCast.get_collider()
					
					if collider.name == "XROrigin3D":
						$VisionRayCast.debug_shape_custom_color = Color(174,0,0)
						print("I see you")
					else:
						$VisionRayCast.debug_shape_custom_color = Color(0,255,0)
						print("I don't see you")
			else:
				print("nni")


#func _on_vision_area_area_entered(area: Area3D) -> void:
	#print("BRUH")
