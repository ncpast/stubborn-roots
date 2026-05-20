extends Node

var purchase_multiplier = 1
var cost_multiplier = 1

var buildings = {
	"windmill": {
		"cost": 1000
	}
}

var plants = {
	"wheat": {
		"purchase": {
			"cost": 5
		},
		"tile_origin_id": 0,
		"sell": {
			"cost": 7
		},
		"growth_time": 100,
		"description": "Wheat grows on soil"
	},
	"carrot": {
		"purchase": {
			"cost": 10
		},
		"tile_origin_id": 2,
		"sell": {
			"cost": 16
		},
		"growth_time": 200,
		"description": "Carrots grow on soil"
	},
	"tomato": {
		"name": "Tomato",
		"purchase": {
			"cost": 15
		},
		"tile_origin_id": 1,
		"sell": {
			"cost": 25
		},
		"growth_time": 130,
		"description": "Tomatoes grow on soil"
	},
	"bread": {
		"name": "Bread",
		"plantable": false,
		"sell": {
			"cost": 50
		},
		"description": "Make bread out of wheat to sell at a higher price"
	}
}
