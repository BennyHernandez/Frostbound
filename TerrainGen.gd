extends Node3D

const HTerrainData = preload("res://addons/zylann.hterrain/hterrain_data.gd")

@onready var _terrain = $HTerrain

func _ready():
	# get terrain image
	var terrain_data : HTerrainData = _terrain.get_data()
	var heightmap : Image = terrain_data.get_image(HTerrainData.CHANNEL_HEIGHT)
	
	var noise = FastNoiseLite.new()
	var noise_multiplier = 2.5
	
	for z in heightmap.get_height():
		for x in heightmap.get_width():
			# Generate height
			var h = noise_multiplier * noise.get_noise_2d(x, z)

			# Getting normal by generating extra heights directly from noise,
			# so map borders won't have seams in case you stitch them
			var h_right = noise_multiplier * noise.get_noise_2d(x + 0.1, z)
			var h_forward = noise_multiplier * noise.get_noise_2d(x, z + 0.1)
			var normal = Vector3(h - h_right, 0.1, h_forward - h).normalized()

			heightmap.set_pixel(x, z, Color(h, 0, 0))
			
	var modified_region = Rect2(Vector2(), heightmap.get_size())
	terrain_data.notify_region_change(modified_region, HTerrainData.CHANNEL_HEIGHT)
	_terrain.update_collider()
