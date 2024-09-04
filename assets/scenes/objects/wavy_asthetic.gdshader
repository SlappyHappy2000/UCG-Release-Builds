shader_type canvas_item;

uniform vec4 blue_tint : source_color;
uniform sampler2D noise_pattern;
uniform vec4 movement_constants = vec4(0.15, -0.05, 0.05, 0.1);
uniform float distortion_strength = 1.0;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 motion1 = vec2(TIME * movement_constants.x, TIME * -movement_constants.y);
    vec2 motion2 = vec2(TIME * movement_constants.z, TIME * movement_constants.a);
    vec2 looping_constant = vec2(1.0, 1.0);
    
    float noise1 = texture(noise_pattern, modf(UV + motion1, looping_constant)).x;
    float noise2 = texture(noise_pattern, modf(UV + motion2, looping_constant)).x;
    
    vec2 distort1 = vec2(noise1) - vec2(0.5);
    vec2 distort2 = vec2(noise2) - vec2(0.5);
    
    vec2 distort_sum = distortion_strength * (distort1 + distort2) / 120.0;
    
    
    vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE;
    float dUVx = SCREEN_UV.x + distort_sum.x;
    float dUVy = SCREEN_UV.y + distort_sum.y;
    //dUVx = (floor(dUVx * resolution.x) + 0.5) / resolution.x;
    //dUVy = (floor(dUVy * resolution.y) + 0.5) / resolution.y;
    
    vec4 color = textureLod(SCREEN_TEXTURE, vec2(dUVx, dUVy), 0.0);
    
    //color = mix(color, blue_tint, 0.4);
    //color.rgb = mix(vec3(UV.y * 0.55 + 0.15), color.rgb, 1.65); 
    
    COLOR = color;
}