extends Camera2D

var dragging = false
var drag_start_mouse = Vector2.ZERO
var drag_start_camera = Vector2.ZERO

var min_x = -250
var max_x = 250

var min_y = -250
var max_y = 250

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			dragging = event.pressed
			if dragging:
				drag_start_mouse = event.position
				drag_start_camera = position
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom = zoom + Vector2(0.1, 0.1)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom = zoom - Vector2(0.1, 0.1)
		zoom = zoom.clamp(Vector2(1.2, 1.2), Vector2(4.5, 4.5))
	
	if event is InputEventMouseMotion and dragging:
		position = drag_start_camera - (event.position - drag_start_mouse) / zoom.x
		position.x = clamp(position.x, min_x, max_x)
		position.y = clamp(position.y, min_y, max_y)
