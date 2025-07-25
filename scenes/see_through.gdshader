shader_type spatial;
stencil_mode write,1, compare_always;
uniform float visibility: hint_range(0.0,1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    // Smooth fade near the outer edge of the sphere
    ALPHA = visibility;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
