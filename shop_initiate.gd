extends Area2D

@export var shopmenu: PackedScene
var currentmenu: Node = null
var mousehover: bool = false

func _ready() -> void:
	mouse_entered.connect(_mouse_enter)
	mouse_exited.connect(_mouse_exit)
	
func _mouse_enter() -> void:
	mousehover = true
	print("true")
	
func _mouse_exit() -> void:
	mousehover = false
	print("faslse")

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	
	if event is InputEventMouseButton:
		if currentmenu == null and shopmenu != null:
			currentmenu = shopmenu.instantiate()
			add_child(currentmenu)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if currentmenu !=null and mousehover == false:
			currentmenu.queue_free()
			currentmenu = null
