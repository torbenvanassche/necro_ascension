shader_type spatial;

stencil_mode read, 1, compare_not_equal;
render_mode unshaded, cull_disabled, blend_mix, depth_draw_never;

void fragment() {
    ALBEDO = vec3(1.0, 0.0, 0.0);
	ALPHA = 1.0;
}
