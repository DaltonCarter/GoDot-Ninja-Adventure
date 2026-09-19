shader_type canvas_item;


uniform sampler2D base_palette : filter_nearest;
uniform sampler2D active_palette : filter_nearest;
uniform int number_of_colors = 3;

void fragment() {
	vec4 current_color = texture(TEXTURE, UV);
	
	if (current_color.a == 0.0) {
		discard;
	}
	
	vec4 final_color = current_color;
	
	for (int i = 0; i < number_of_colors; i++) {
		float uv_x = (float(i) + 0.5) / float(number_of_colors);
		vec4 palette_color = texture(base_palette, vec2(uv_x, 0.5));
		
		if (distance(current_color.rgb, palette_color.rgb) < 0.01) {
			final_color = texture(active_palette, vec2(uv_x, 0.5));
			break;
		}
	}
	
	COLOR = vec4(final_color.rgb, current_color.a);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
