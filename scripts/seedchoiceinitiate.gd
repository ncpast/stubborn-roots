extends Button

@export var seedlist: PackedScene
var currentlist: Node = null

func _pressed() -> void:
	if currentlist != null:
		
		currentlist.queue_free()
		currentlist = null
		get_parent().remove_child(currentlist)
		print(currentlist)
	
	else:
		currentlist = seedlist.instantiate()
		get_parent().add_child(currentlist)
		print(currentlist)
