extends Button

@export var seedlist: PackedScene
@onready var click = $"../../../Sounds/Click"
var currentlist: Node = null

func _pressed() -> void:
	click.play()
	if is_instance_valid(currentlist):
		currentlist.queue_free()
		currentlist = null
		self.icon = load("res://assets/ui/Slot_UnSelected.png")
	else:
		currentlist = seedlist.instantiate()
		
		# 1. Get the VBoxContainer (the parent)
		var parent_container = get_parent()
		
		# 2. Add the list to the container
		parent_container.add_child(currentlist)
		
		# 3. Force the list to the top of the container (Index 0)
		# This guarantees it stacks ABOVE the big button!
		parent_container.move_child(currentlist, 0)
		
		self.icon = load("res://assets/ui/Slot_Selected.png")
