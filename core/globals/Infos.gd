extends Node

var fishes: Dictionary = {
	"test1": {"speed": 80.0, "max_in_shoals": 5, "rotation": 0.1, "orbit_radius": 50, "difficulty": 2, "size": 30, "duration": 0.8, "description": "Gros poisson bleuté qui va vite tah les oufs. nan vrament la vitesse du man est impressionantes."},
	"test2": {"speed": 30.0, "max_in_shoals": 15, "rotation": 0.1, "orbit_radius": 50, "difficulty": 1, "size": 50, "duration": 1.2, "description": "petit poisson vert. il est la il chill. rien de particulier sur lui."}, 
}

func get_fishes_info(fish: String) -> Dictionary:
	return fishes[fish]

func get_max_offset(fish: String) -> float:
	return fishes[fish]["orbit_radius"] * 2
