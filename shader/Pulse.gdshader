shader_type canvas_item;

uniform float zoom_speed : hint_range(0.1, 10.0) = 1.0;
uniform float zoom_min : hint_range(0.1, 1.0) = 0.5;
uniform float zoom_max : hint_range(1.0, 5.0) = 1.5;

void fragment() {
	float zoom = mix(zoom_min, zoom_max, 0.5 + 0.5 * sin(TIME * zoom_speed));

	vec2 uv = 0.5 + (UV - 0.5) / zoom;

	if(uv.x >1.0 || uv.x < 0.0 || uv .y < 0.0 || uv.y > 1.0){
		COLOR.a = 0.0;
	} else{

	    COLOR = texture(TEXTURE, uv);
	}
}
