shader_type canvas_item;

uniform vec4 line_color : source_color = vec4(1.0);
uniform float line_thickness : hint_range(0, 10) = 1.0;

// On crée une variable "varying" pour transmettre la modulation sans la texture
varying vec4 modulate_color;

void vertex() {
    // Dans le vertex, COLOR contient UNIQUEMENT la couleur de modulation du nœud
    modulate_color = COLOR;
}

const vec2 OFFSETS[8] = {
    vec2(-1, -1), vec2(-1, 0), vec2(-1, 1), vec2(0, -1), vec2(0, 1), 
    vec2(1, -1), vec2(1, 0), vec2(1, 1)
};

void fragment() {
    vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;
    float outline = 0.0;
    
    // 1. Calcul de l'outline basé sur la texture brute (l'alpha est intact !)
    for (int i = 0; i < OFFSETS.length(); i++) {
        outline += texture(TEXTURE, UV + size * OFFSETS[i]).a;
    }
    outline = min(outline, 1.0);
    
    // 2. On récupère la couleur d'origine du sprite
    vec4 texture_color = texture(TEXTURE, UV);
    
    // 3. On crée le mix de base (Sprite + Outline d'origine)
    vec4 final_color = mix(texture_color, line_color, outline - texture_color.a);
    
    // 4. On applique la modulation stockée à la toute fin sur l'ensemble
    COLOR = final_color * modulate_color;
}