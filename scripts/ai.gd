extends CharacterBody3D

@onready var nav_agent := $NavigationAgent3D as NavigationAgent3D
@onready var Target := get_parent().get_node("XROrigin3D/PlayerBody")
#@onready var Target := $"../XROrigin3D/PlayerBody" 
@onready var Chasing: bool = false
@onready var randomPos = Vector3(randf_range(-50, 50), position.y, randf_range(-50, 50))

#@onready var chaseSpeed = 5.0
@onready var swimSpeed = 3.0
@onready var wanderTimer = 20.0

var speed
func _ready():
	set_physics_process(false)
	await get_tree().physics_frame
	set_physics_process(true)

func  _physics_process(_delta: float) -> void:
	var speed = swimSpeed
	if Chasing:
		chase()
		#speed = chaseSpeed
		$AlertSound.play()
	else: 
		#speed = swimSpeed
		wander(_delta)
	#look_at(Target.global_transform.origin, Vector3.UP)
	var current_position = global_transform.origin
	var next_position := nav_agent.get_next_path_position()
	#var new_velocity = (next_position - current_position).normalized() * speed
	#nav_agent.set_velocity_forced(new_velocity)
	#var offset := next_position - global_transform.origin
	var direction = nav_agent.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction * speed, _delta * 10)

	global_position = global_position.move_toward(next_position, _delta * speed)
	#offset.y = 0


func update_target_location(target_location)-> void:
	nav_agent.target_position = target_location

func vision_sighter():
	print(Chasing)
	var overlaps = $VisionArea.get_overlapping_bodies()
	if overlaps.size() > 0:
		for overlap in overlaps:
			print(overlap)
			if overlap == Target:	
				if $VisionRayCast.is_colliding():
					var collider = $VisionRayCast.get_collider()
					if collider.name == "PlayerBody":
						$VisionRayCast.debug_shape_custom_color = Color(174,0,0)
						Chasing = true
						print("I see you")
					else:
						$VisionRayCast.debug_shape_custom_color = Color(0,255,0)
						Chasing = false
						print("I don't see you")
			#else:
				#print("kini")
				#Chasing = false
 
func _on_detecting_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player_body"):
		print("conte")
		Chasing = true
		
func _on_detecting_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player_body"):
		var lastPos = body.global_position
		randomPos = lastPos
		Chasing = false

func chase():
	look_at(Target.global_transform.origin, Vector3.UP)
	nav_agent.target_position = Target.global_transform.origin

func wander(delta):
	look_at(global_transform.origin + velocity)
	nav_agent.target_position = randomPos
	if (abs(randomPos.x - global_position.x) <= 5 and abs(randomPos.z - global_position.z) <= 5) or wanderTimer <= 0:
		randomPos = Vector3(randf_range(Target.global_position.x - 40, Target.global_position.x + 40), position.y, randf_range(Target.global_position.z - 40, Target.global_position.z + 40))
		clamp(randomPos.x, -50, 50)
		clamp(randomPos.z, -50, 50)
		wanderTimer = 20.0
	wanderTimer -= delta

func _on_navigation_agent_3d_target_reached():
	print("in range")

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, .25)
	move_and_slide()

func _on_timer_timeout() -> void:
	vision_sighter()


#func _on_vision_area_area_entered(area: Area3D) -> void:
	#print("BRUH")
