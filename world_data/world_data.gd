extends Node

var purchase_multiplier = 1
var cost_multiplier = 1

var plants = {
	"Wheat": {
		"purchase": {
			"cost": 5
		},
		"sell": {
			"cost": 40
		},
		"growth_time": 100,
		"description": "Wheat grows on soil"
	},
	"Potato": {
		"purchase": {
			"cost": 2
		},
		"sell": {
			"cost": 20
		},
		"growth_time": 30,
		"description": "Potato grows on soil"
	},
	"Tomato": {
		"name": "Tomato",
		"purchase": {
			"cost": 7
		},
		"sell": {
			"cost": 80
		},
		"growth_time": 130,
		"description": "Tomato grows on soil"
	},
}
