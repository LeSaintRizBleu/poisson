shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec4 color : source_color = vec4(0.0, 0.25, 1.0, 0.8);
uniform float frequency : hint_range(0.0, 100.0, 0.1) = 2.5;
uniform float speed : hint_range(-10.0, 10.0, 0.01) = 0.15;
uniform float amplitude : hint_range(0.0, 0.1, 0.001) = 0.05;

vec2 distort(vec2 uv) {
    float time = TIME * speed;
    float wave1 = sin(uv.x * frequency + time) * amplitude;
    float wave2 = cos(uv.y * frequency + time) * amplitude;
    return uv + vec2(wave1, wave2);
}

void fragment() {
    vec2 pixel_size = SCREEN_PIXEL_SIZE;
    vec2 base_uv = UV;
    vec2 distorted_uv = distort(base_uv);
    distorted_uv = (floor(distorted_uv / pixel_size) + 0.5) * pixel_size;
    vec4 background_color = texture(screen_texture, distorted_uv);
    vec4 final_color = mix(background_color, color, 0.3);
    COLOR = final_color;
}