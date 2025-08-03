shader_type spatial;
stencil_mode write,1, compare_always;
uniform float visibility: hint_range(0.0,1.0);

void fragment() {
    // Smooth fade near the outer edge of the sphere
    ALPHA = visibility;
}
