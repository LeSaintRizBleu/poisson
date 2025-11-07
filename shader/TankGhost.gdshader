shader_type canvas_item;

// Outline
uniform float outline_width : hint_range(0, 10) = 3.0;
uniform vec4 outline_color = vec4(1.0, 1.0, 1.0, 1.0);

// Couleur verte et transparence
uniform vec4 target_color = vec4(0.0, 1.0, 0.0, 0.5);
uniform float darken_factor : hint_range(0.1, 0.9) = 0.5;

// Hachures
uniform float hatch_density : hint_range(0.1, 20.0) = 10.0;
uniform float hatch_speed : hint_range(0.0, 5.0) = 1.0;
uniform float hatch_width : hint_range(0.1, 1.0) = 0.5;

void fragment() {
    // Couleur de base du sprite
    vec4 base_color = texture(TEXTURE, UV);
    float original_alpha = base_color.a;
    
    COLOR = vec4(0.0);
    
    // Si le pixel n'est pas transparent
    if (original_alpha > 0.0) {
        vec2 pixel_size = TEXTURE_PIXEL_SIZE * outline_width;
        bool is_near_empty = false;
        bool is_near_screen_edge = false;
        
        // NOUVELLE MÉTHODE pour is_near_empty
        float empty_detection = 0.0;
        
        // Vérifie tous les pixels dans un rayon autour
        for (float x = -1.0; x <= 1.0; x += 1.0) {
            for (float y = -1.0; y <= 1.0; y += 1.0) {
                // Saute le pixel central
                if (x == 0.0 && y == 0.0) continue;
                
                vec2 offset = vec2(x, y) * pixel_size;
                float neighbor_alpha = texture(TEXTURE, UV + offset).a;
                
                // Si au moins un voisin est transparent, c'est un bord
                if (neighbor_alpha < 0.1) {
                    is_near_empty = true;
                    break;
                }
            }
            if (is_near_empty) break;
        }
        
        // Vérifie si proche du bord de l'écran
        float edge_threshold = outline_width * 0.01;
        if (UV.x < edge_threshold || UV.x > (1.0 - edge_threshold) ||
            UV.y < edge_threshold || UV.y > (1.0 - edge_threshold)) {
            is_near_screen_edge = true;
        }
        
        // Combine les deux conditions
        bool should_have_outline = is_near_empty || is_near_screen_edge;
        
        // Hachures animées
        float hatch_pattern = sin((UV.x + UV.y) * hatch_density + TIME * hatch_speed);
        hatch_pattern = abs(hatch_pattern);
        float hatch_alpha = step(hatch_width, hatch_pattern);
        
        // Calcul du vert foncé
        vec4 dark_green_color = vec4(
            target_color.r * darken_factor,
            target_color.g * darken_factor,
            target_color.b * darken_factor,
            target_color.a
        );
        
        // Logique : si proche d'un vide OU proche du bord → outline, sinon → hachures
        if (should_have_outline) {
            // Outline
            COLOR = outline_color;
            COLOR.a = original_alpha;
        } else {
            // Hachures à l'intérieur
            if (hatch_alpha > 0.5) {
                COLOR = mix(base_color, target_color, 0.7);
            } else {
                COLOR = mix(base_color, dark_green_color, 0.8);
            }
        }
    }
}