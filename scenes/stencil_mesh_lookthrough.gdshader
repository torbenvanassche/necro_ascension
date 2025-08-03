shader_type spatial;
render_mode unshaded, depth_draw_never, depth_test_disabled, cull_disabled;

stencil_mode read, compare_equal, 1;

void fragment() {
    discard;
}