extends Button

@export var seedlist: PackedScene
var currentlist: Node = null

func _pressed() -> void:
	if is_instance_valid(currentlist):
		currentlist.queue_free()
		currentlist = null
	else:
		currentlist = seedlist.instantiate()
		get_parent().add_child(currentlist)
