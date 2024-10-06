shader_type canvas_item;

uniform sampler2D lupa_texture: hint_screen_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR = texture(lupa_texture, SCREEN_UV);
	COLOR.a = texture(lupa_texture, UV).a;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
