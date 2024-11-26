shader_type spatial;

/**
 * The Dither texture, affects the way the dithering will be rendered.
 */
uniform sampler2D DitherMap;

/**
 * The intensity of dithering effect, where higher values produce more visible dithering noise.
 */
uniform float DitherStrength : hint_range(0.0, 0.5) = 0.1;

/**
 * Controls the number of distinct light levels; higher values produce smoother lighting.
 */
uniform float ColorDepth : hint_range(1.0, 100.0) = 3.0;

/**
 * Sets the size of the dither pattern tiles. Larger values mean smaller tiles.
 */
uniform float DitherScale : hint_range(1.0, 100.0) = 16.0;

/**
 * Determines how rapidly the light intensity decreases with distance.
 */
uniform float FalloffStrength : hint_range(0.1, 10.0) = 1.0; 

/**
 * Controls the vibrancy of the light color before blending into the target color.
 */
uniform float LightSaturation : hint_range(0.0, 1.0) = 1.0; 

/**
 * The target color that the light will blend into as it fades out.
 */
uniform vec4 TargetColor : source_color = vec4(1.0, 1.0, 1.0, 1.0); 

/**
 * The point at which the light starts blending into the target color..
 */
uniform float BlendStart : hint_range(0.0, 1.0) = 0.5;

void light() {
    float light_intensity = max(0.0, dot(NORMAL, LIGHT)) * ATTENUATION;

    float falloff = pow(ATTENUATION, FalloffStrength);

    vec2 dither_map_size = vec2(textureSize(DitherMap, 0));
    vec2 dither_uv = mod(floor(FRAGCOORD.xy * DitherScale), dither_map_size) / dither_map_size;
    float dither_value = texture(DitherMap, dither_uv).r;

    light_intensity += (dither_value - 0.5) * DitherStrength;
    light_intensity = round(light_intensity * ColorDepth) / ColorDepth;

    float blend_factor = clamp((1.0 - ATTENUATION) / (1.0 - BlendStart), 0.0, 1.0);
    vec3 desaturated_light_color = mix(LIGHT_COLOR.rgb, TargetColor.rgb, blend_factor);
    vec3 final_light_color = mix(TargetColor.rgb, desaturated_light_color, LightSaturation);

    DIFFUSE_LIGHT += light_intensity * falloff * ALBEDO * final_light_color;
}
