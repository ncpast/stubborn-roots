extends GPUParticles2D

const SEASON_CONFIGS = {
	"summer": null,
	"autumn": { "color": Color(0.98, 0.744, 0.532, 1.0), "amount": 400, "speed": 45.0, "spread": 30.0, "scale": 3.0 },
	"winter": { "color": Color(1.0, 1.0, 1.0, 0.9), "amount": 2000, "speed": 30.0, "spread": 10.0, "scale": 1.5 },
	"spring": { "color": Color(1.0, 0.783, 0.888, 1.0), "amount": 300, "speed": 30.0, "spread": 25.0, "scale": 2.5 }
}
const SEASON_NAMES = ["summer", "autumn", "winter", "spring"]

func _ready() -> void:
	apply_season()

func apply_season() -> void:
	restart()
	var season_name = SEASON_NAMES[WorldData.current_season % 4]
	var config = SEASON_CONFIGS[season_name]
	if config == null:
		emitting = false
		return
	emitting = true
	lifetime = 12.0  # long enough to cross the screen
	amount = config["amount"]
	var mat = process_material as ParticleProcessMaterial
	mat.color = config["color"]
	mat.direction = Vector3(-1.0, 1.0, 0.0)  # 45 degree angle
	mat.initial_velocity_min = config["speed"] * 0.8
	mat.initial_velocity_max = config["speed"]
	mat.gravity = Vector3(0, 0, 0)  # disable gravity, use velocity instead
	mat.spread = config["spread"]
	mat.scale_min = config["scale"] * 0.8
	mat.scale_max = config["scale"]
	mat.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	mat.emission_box_extents = Vector3(1000, 500, 0)
	preprocess = lifetime / 2
