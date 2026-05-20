extends GPUParticles2D

const SEASON_CONFIGS = {
	"summer": null,
	"autumn": {
		"color": Color(0.85, 0.4, 0.1, 1.0),
		"amount": 40,
		"speed": 60.0,
		"spread": 30.0,
		"scale": 3.0
	},
	"winter": {
		"color": Color(1.0, 1.0, 1.0, 0.9),
		"amount": 80,
		"speed": 30.0,
		"spread": 10.0,
		"scale": 1.5
	},
	"spring": {
		"color": Color(1.0, 0.7, 0.85, 1.0),
		"amount": 40,
		"speed": 45.0,
		"spread": 25.0,
		"scale": 2.5
	}
}

const SEASON_NAMES = ["summer", "autumn", "winter", "spring"]

func _ready() -> void:
	_setup_particles()
	var material = ParticleProcessMaterial.new()
	process_material = material
	apply_season()

func apply_season() -> void:
	var season_name = SEASON_NAMES[WorldData.current_season % 4]
	var config = SEASON_CONFIGS[season_name]
	if config == null:
		emitting = false
		return
	emitting = true
	amount = config["amount"]
	var mat = process_material as ParticleProcessMaterial
	mat.color = config["color"]
	mat.direction = Vector3(0.3, 1.0, 0)   # slight sideways drift
	mat.spread = config["spread"]
	mat.gravity = Vector3(0, config["speed"], 0)
	mat.scale_min = config["scale"] * 0.8
	mat.scale_max = config["scale"]
	mat.angular_velocity_min = -45.0        # gentle spin
	mat.angular_velocity_max = 45.0

func _setup_particles() -> void:
	lifetime = 6.0
	explosiveness = 0.0
	randomness = 1.0
	fixed_fps = 0
	# spawn across the top of the screen
	position = Vector2(576, -20)            # adjust to your viewport width center
	var mat = ParticleProcessMaterial.new()
	mat.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	mat.emission_box_extents = Vector3(600, 1, 0)  # adjust to viewport width
	process_material = mat
