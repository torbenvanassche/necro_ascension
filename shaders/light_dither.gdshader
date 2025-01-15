shader_type spatial;

uniform sampler2D DitherMap;
uniform float DitherStrength : hint_range(0.0, 0.5) = 0.1;
uniform float ColorDepth : hint_range(1.0, 100.0) = 3.0;
uniform float DitherScale : hint_range(1.0, 100.0) = 16.0;
uniform float FalloffStrength : hint_range(0.1, 10.0) = 1.0;
uniform float LightSaturation : hint_range(0.0, 1.0) = 1.0;
uniform vec4 TargetColor : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float BlendStart : hint_range(0.0, 1.0) = 0.5;

void light() {
    float light_intensity = max(0.0, dot(NORMAL, LIGHT)) * ATTENUATION;
    float falloff = pow(ATTENUATION, FalloffStrength);

    vec2 dither_map_size = vec2(textureSize(DitherMap, 0));
    vec2 dither_uv = mod(floor(FRAGCOORD.xy * DitherScale), dither_map_size) / dither_map_size;
    float dither_value = texture(DitherMap, dither_uv).r;

    light_intensity += (dither_value - 0.5) * DitherStrength;
    light_intensity = round(light_intensity * ColorDepth) / ColorDepth;

    float transition = (1.0 - BlendStart);
    float smooth_factor = smoothstep(0.0, transition, 1.0 - ATTENUATION);
    vec3 blended_color = mix(LIGHT_COLOR.rgb, TargetColor.rgb, smooth_factor);

    vec3 final_light_color = mix(LIGHT_COLOR.rgb, blended_color, 1.0 - LightSaturation);

    DIFFUSE_LIGHT += light_intensity * falloff * ALBEDO * final_light_color;
}
