shader_type spatial;

stencil_mode write, 1, compare_always;
render_mode depth_draw_always, depth_test_disabled, unshaded, cull_disabled;

void fragment() {
    ALPHA = 0.0;
}