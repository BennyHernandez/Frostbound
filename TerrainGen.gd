extends Node3D

const HTerrainData = preload("res://addons/zylann.hterrain/hterrain_data.gd")

@onready var _terrain = $HTerrain

var noise = FastNoiseLite.new()
@export var noise_multiplier = 2.5
@export var islandFloor = 50

@export var edgeRandomnessMin = 5
@export var edgeRandomnessMax = 10

func _ready():
	# get terrain image
	var terrain_data : HTerrainData = _terrain.get_data()
	var heightmap : Image = terrain_data.get_image(HTerrainData.CHANNEL_HEIGHT)
	
	
	
	var centerPoint = Vector2(heightmap.get_width()/2.0,heightmap.get_height()/2.0)
	var islandRadius = (heightmap.get_width()/2.0)-100

	heightmap.fill(Color(0, 0, 0))
	genCircle(centerPoint, islandRadius, heightmap)

	var outerRadius = islandRadius

	for theta : float in range(720): # double 360 for half degrees 
		theta = theta/2.0
		var x = centerPoint.x + outerRadius * cos(theta * (PI/180))
		var y = centerPoint.y + outerRadius * sin(theta * (PI/180))
		var randRadius = randf_range(edgeRandomnessMin, edgeRandomnessMax)
		
		genCircle(Vector2(x,y), randRadius, heightmap)

			
	var modified_region = Rect2(Vector2(), heightmap.get_size())
	terrain_data.notify_region_change(modified_region, HTerrainData.CHANNEL_HEIGHT)
	_terrain.update_collider()

func genCircle(pos: Vector2, radius: float, image: Image):
	for x in range(pos.x - radius, pos.x+radius+1):
		# var yspan = radius*sin(acos((pos.x-x)/radius))
		for y in range(pos.y - radius, pos.y+radius+1):
			if ((x - pos.x)*(x - pos.x) + (y - pos.y)*(y - pos.y) <= radius*radius):
				# Generate height for terrain roughness + floor value
				var h = noise_multiplier * noise.get_noise_2d(x, y) + islandFloor
				image.set_pixel(x, y, Color(h, 0, 0))

				# Set symetrical pixels as well
				var xSym = pos.x - (x - pos.x);
				var ySym = pos.y - (y - pos.y);
				var hSym = noise_multiplier * noise.get_noise_2d(ySym, ySym) + islandFloor
				image.set_pixel(xSym, ySym, Color(hSym, 0, 0))
	
