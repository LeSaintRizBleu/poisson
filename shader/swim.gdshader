shader_type canvas_item;

uniform float speed : hint_range(0.1, 5.0) = 1.0;
uniform float body_amplitude : hint_range(0.01, 0.2) = 0.025;
uniform float tail_amplitude : hint_range(0.05, 0.3) = 0.10;
uniform float frequency : hint_range(2.0, 20.0) = 6.0;
uniform float body_length : hint_range(0.1, 0.9) = 0.5;

void fragment() {
	vec2 uv = UV;
	float time = TIME * speed;
	float body_pos = smoothstep(0.0, body_length, uv.x);

	float wave = sin(uv.x * frequency - time * 4.0);
	float amplitude = mix(body_amplitude, tail_amplitude, body_pos);
	float offset = wave * amplitude;
	float edge_protection = uv.y * (1.0 - uv.y) * 4.0;

	uv.y += offset * edge_protection;
	uv.x += offset * 0.1 * (1.0 - uv.y);

	vec4 tex_color = texture(TEXTURE, uv);
	COLOR = tex_color;
}