shader_type canvas_item;
uniform int repeat_count = 10;
uniform vec2 sprite_scale = vec2(1.0, 1.0);
uniform vec2 mouse_position;
uniform bool show_sprite = true;
const float center = 20.0;
const float falloff = 150.0;

void fragment() {
    if (show_sprite) {
        vec2 scaled_uv = UV * sprite_scale;
        vec2 repeated_uv = fract(scaled_uv * float(repeat_count));
        vec4 tex_color = texture(TEXTURE, repeated_uv);

        if (tex_color.a != 0.0) {
            float dist = distance(mouse_position, VERTEX);
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
