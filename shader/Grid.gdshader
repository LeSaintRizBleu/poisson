shader_type canvas_item;

uniform int repeat_count = 10;
uniform vec2 sprite_scale = vec2(1.0, 1.0);
uniform vec2 position_a;
uniform vec2 position_b;
uniform bool show_sprite = true;

const float center = 20.0;
const float falloff = 150.0;

float dist_to_segment(vec2 p, vec2 a, vec2 b) {
    vec2 ab = b - a;
    vec2 ap = p - a;
    float t = clamp(dot(ap, ab) / dot(ab, ab), 0.0, 1.0);
    vec2 closest = a + t * ab;
    return distance(p, closest);
}

void fragment() {
    if (show_sprite) {
        vec2 scaled_uv = UV * sprite_scale;
        vec2 repeated_uv = fract(scaled_uv * float(repeat_count));
        vec4 tex_color = texture(TEXTURE, repeated_uv);

        if (tex_color.a != 0.0) {
            float dist = dist_to_segment(VERTEX, position_a, position_b);
            float alpha = clamp(1.0 - (dist - center) / falloff, 0.0, 1.0);
            COLOR.a = tex_color.a * alpha;
            COLOR.rgb = mix(tex_color.rgb, vec3(1.0), alpha);
        } else {
            COLOR = tex_color;
        }
    } else {
        COLOR = vec4(0.0);
    }
}