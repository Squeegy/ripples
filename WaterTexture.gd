extends Sprite2D

const MAX_RIPPLES = 10
var ripple_centers = []
var time_since_ripple = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range (MAX_RIPPLES):
		ripple_centers.append(Vector2(-1,-1))
		time_since_ripple.append(0.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var viewport_size = get_viewport_rect().size
	var texture_size = texture.get_size()
	
	# Scale sprite to match the viewport size
	scale.x = viewport_size.x / texture_size.x
	scale.y = viewport_size.y / texture_size.y
	# Center sprite in the viewport
	position = viewport_size / 2
	
	# Update ripple time
	for i in range(time_since_ripple.size()):
		time_since_ripple[i] += delta

	if material is ShaderMaterial:
		material.set_shader_parameter("ripple_centers", ripple_centers)
		material.set_shader_parameter("time_since_ripple", time_since_ripple)
		material.set_shader_parameter("viewport_size", get_viewport().size)
		print(ripple_centers)
		print(time_since_ripple)
	

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_pos = event.position
		var viewport_size = get_viewport_rect().size
		var normalized_pos = Vector2(mouse_pos.x / viewport_size.x, mouse_pos.y/ viewport_size.y)
		
		append_queue(ripple_centers, normalized_pos)
		append_queue(time_since_ripple, 0.0)
		
func append_queue(queue, element):
	queue.pop_back()
	queue.push_front(element)
