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
 * The point at which the light starts blending into the target color.
 */
uniform float BlendStart : hint_range(0.0, 1.0) = 0.5;

void light() {
    // Base light intensity based on angle and attenuation
    float light_intensity = max(0.0, dot(NORMAL, LIGHT)) * ATTENUATION;

    // Apply falloff to the light intensity
    float falloff = pow(ATTENUATION, FalloffStrength);

    // Calculate dithering effect
    vec2 dither_map_size = vec2(textureSize(DitherMap, 0));
    vec2 dither_uv = mod(floor(FRAGCOORD.xy * DitherScale), dither_map_size) / dither_map_size;
    float dither_value = texture(DitherMap, dither_uv).r;

    // Add dithering to light intensity
    light_intensity += (dither_value - 0.5) * DitherStrength;

    // Quantize light intensity to the specified color depth
    light_intensity = round(light_intensity * ColorDepth) / ColorDepth;

    // Blend light color with target color based on a smoother blend factor
    float transition = (1.0 - BlendStart);
    float smooth_factor = smoothstep(0.0, transition, 1.0 - ATTENUATION);
    vec3 blended_color = mix(LIGHT_COLOR.rgb, TargetColor.rgb, smooth_factor);

    // Adjust the vibrancy of the blended color
    vec3 final_light_color = mix(LIGHT_COLOR.rgb, blended_color, 1.0 - LightSaturation);

    // Calculate final diffuse light contribution
    DIFFUSE_LIGHT += light_intensity * falloff * ALBEDO * final_light_color;
}
