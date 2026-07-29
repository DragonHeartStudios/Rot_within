shader_type canvas_item;

uniform vec2 offset = vec2(5.0, 5.0); // Décalage de l'ombre en pixels
uniform vec4 shadow_color : source_color = vec4(0.0, 0.0, 0.0, 0.5); // Noir transparent

void fragment() {
    // On récupère la couleur texturée normale
    vec4 col = texture(TEXTURE, UV);
    
    // On récupère la texture décalée pour l'ombre
    vec2 size = TEXTURE_PIXEL_SIZE;
    vec4 shadow = texture(TEXTURE, UV - (offset * size));
    
    // On mélange l'ombre et l'image (l'image passe au-dessus)
    vec4 final_color = mix(shadow_color * shadow.a, col, col.a);
    
    COLOR = final_color;
}