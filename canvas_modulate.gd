extends CanvasModulate

@export_group("Cycle Durations")
@export var day_duration: float = 20.0  
@export var night_duration: float = 10.0  

@export_group("Visuals")
@export var gradient: Gradient

var time: float = 0.0
var is_day: bool = true

func _process(delta: float) -> void:
	var current_duration = day_duration if is_day else night_duration
	
	time += (delta / current_duration) * 0.5
	
	if is_day and time >= 0.5:
		is_day = false
		print("Night falls...")
	elif not is_day and time >= 1.0:
		is_day = true
		time = 0.0
		print("Day breaks...")
	
	if gradient:
		self.color = gradient.sample(time)
