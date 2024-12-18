shader_type spatial;
render_mode depth_prepass_alpha;

uniform sampler2D DitherMap;
uniform sampler2D BaseTexture : filter_nearest;
uniform float DitherStrength : hint_range(0.0, 0.5) = 0.1;
uniform float ColorDepth : hint_range(1.0, 100.0) = 3.0;
uniform float DitherScale : hint_range(1.0, 100.0) = 16.0;
uniform float FalloffStrength : hint_range(0.1, 10.0) = 1.0;
uniform float LightSaturation : hint_range(0.0, 1.0) = 1.0;
uniform vec4 TargetColor : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float BlendStart : hint_range(0.0, 1.0) = 0.5;
uniform float MaxBrightness : hint_range(0.0, 10.0) = 2.0;
uniform bool Transparent = false;

void fragment() {
    // Sample the base texture
    vec4 base_texture_color = texture(BaseTexture, UV);

    // Handle missing or default textures
    if (base_texture_color.a == 0.0 && !Transparent) {
        ALBEDO = vec3(1.0); // Default white color
        ALPHA = 1.0;        // Fully opaque
    } else {
        ALBEDO = base_texture_color.rgb;
        ALPHA = base_texture_color.a;
    }
}

void light() {
    // Calculate light intensity with shadowing inherently included in ATTENUATION
    float light_intensity = max(0.0, dot(NORMAL, LIGHT)) * ATTENUATION;

    float falloff = pow(max(0.001, ATTENUATION), FalloffStrength);

    // Apply dithering
    vec2 dither_map_size = vec2(textureSize(DitherMap, 0));
    vec2 dither_uv = mod(floor(FRAGCOORD.xy * DitherScale), dither_map_size) / dither_map_size;
    float dither_value = texture(DitherMap, dither_uv).r;

    light_intensity += (dither_value - 0.5) * DitherStrength;
    light_intensity = clamp(round(light_intensity * ColorDepth) / ColorDepth, 0.0, 1.0);
    light_intensity = min(light_intensity, MaxBrightness);
    light_intensity = light_intensity / (1.0 + light_intensity);

    // Blend target color with light color based on distance
    float transition = (1.0 - BlendStart);
    float smooth_factor = smoothstep(0.0, transition, 1.0 - ATTENUATION);
    vec3 blended_color = mix(LIGHT_COLOR.rgb, TargetColor.rgb, smooth_factor);

    vec3 final_light_color = mix(LIGHT_COLOR.rgb, blended_color, 1.0 - LightSaturation);

    // Apply light calculations to final diffuse light
    DIFFUSE_LIGHT += clamp(light_intensity * falloff * ALBEDO * final_light_color, 0.0, 1.0);
}
