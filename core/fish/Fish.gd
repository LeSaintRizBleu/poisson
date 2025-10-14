extends Node2D
class_name Fish

@export var orbit_speed: float = 0.1
@export var orbit_radius: float = 10.0
@export var rotation_speed: float = 5.0

@onready var sprite: Sprite2D = $Visuals/Sprite
@onready var swim_particules: CPUParticles2D = $Visuals/SwimParticules
@onready var visuals:Node2D = $Visuals

var offset: Vector2
var speed: float = 10.0

func update_fish(delta: float, shoal_position: Vector2, shoal_direction: Vector2) -> void:
	var angle: float = offset.angle()
	angle += orbit_speed * delta
	offset = Vector2(cos(angle), sin(angle)) * orbit_radius

	var target_position: Vector2 = shoal_position + offset
	global_position = global_position.lerp(target_position, speed * delta)

	var target_rotation: float = shoal_direction.angle()
	visuals.rotation = lerp_angle(visuals.rotation, target_rotation, rotation_speed * delta)

	sprite.flip_h = true
	sprite.flip_v = shoal_direction.x < 0

func init(type: String) -> void:
	var data: Dictionary = Infos.get_fishes_info(type)
	
	orbit_speed = data["rotation"]
	var radius: float = data["orbit_radius"]

	orbit_radius = randf_range(radius/2, radius*2)
	orbit_speed = randf_range(orbit_speed, orbit_speed*4)
	rotation_speed = randf_range(2.0, 10.0)

	var url: String = "res://assets/fishes/" + type + ".png"
	var texture: CompressedTexture2D = load(url)
	sprite.texture = texture
	var randomScale: float = randf_range(0.75, 1.5)
	sprite.scale = Vector2(randomScale, randomScale)
	var darkness: float = randf_range(0.0, 0.25)
	var shaderMaterial: ShaderMaterial = sprite.material as ShaderMaterial
	shaderMaterial.set_shader_parameter("darkness", darkness)

	var width: float = texture.get_width()
	var height: float = texture.get_height()

	swim_particules.position = Vector2(-width/3, 0)
	swim_particules.emission_sphere_radius = height/3
