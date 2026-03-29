extends CanvasModulate

@export_group("Cycle Durations")
@export var day_duration: float = 20.0 * 10
@export var night_duration: float = 10.0 * 10

@export_group("Visuals")
@export var gradient: Gradient

var time: float = 0.5
var is_day: bool = true

func _ready() -> void:
	if time >= 0.2 and time < 0.85:
		is_day = true
		toggle_lights(false)
		print("Started during Day: Lights OFF")
	else:
		is_day = false
		toggle_lights(true)
		print("Started during Night: Lights ON")

func _process(delta: float) -> void:
	var current_duration = day_duration if is_day else night_duration
	time += (delta / current_duration) * 0.5
	
	if time >= 1.0:
		time = 0.0

	if is_day:
		if time >= 0.85:
			is_day = false
			toggle_lights(true)
			print("Sunset reached: Switching to NIGHT")
	else:
		if time >= 0.2 and time < 0.5:
			is_day = true
			toggle_lights(false)
			print("Sunrise reached: Switching to DAY")

	if gradient:
		self.color = gradient.sample(time)

func toggle_lights(on: bool) -> void:
	get_tree().call_group("lights", "set_enabled", on)
