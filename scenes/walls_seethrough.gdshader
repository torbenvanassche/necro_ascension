shader_type spatial;
render_mode depth_draw_never, depth_test_disabled;
stencil_mode read, compare_not_equal, 1;
uniform vec3 color:source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	//ALBEDO = color;
    ALPHA = 1.0;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
