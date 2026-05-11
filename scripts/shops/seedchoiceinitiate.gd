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
		get_parent().add_child(currentlist)
		self.icon = load("res://assets/ui/Slot_Selected.png")
