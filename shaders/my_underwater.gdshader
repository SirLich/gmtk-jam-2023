shader_type spatial;

// Setup
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;
uniform sampler2D depth_texture : hint_depth_texture, repeat_disable, filter_nearest;

// Exported Variables
uniform vec4 water_tint : source_color = vec4(0.2, 0.6, 1.0, 0.1);
uniform float background_blur = 5.0;
uniform float view_distance = 20.0f;
render_mode unshaded;

// second
varying mat4 CAMERA;

void vertex() {
	CAMERA = INV_VIEW_MATRIX;
}

vec4 blend2(vec4 first, vec4 second, float factor){
	return first;
}


void fragment() {
	// Calculate Depth
	float depth_tex = texture(depth_texture, SCREEN_UV).x;
	vec3 ndc = vec3(SCREEN_UV, depth_tex) * 2.0 - 1.0;
	vec4 world = CAMERA * INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	vec3 world_position = world.xyz / world.w;
	
	float depth = mix(1, 0, world_position.z / view_distance);
	depth = clamp(0, 1, depth);
	
	vec3 depth_preview = vec3(depth, depth, depth);
	
	vec4 far_render = textureLod(screen_texture, SCREEN_UV, background_blur);
	vec4 near_render = textureLod(screen_texture, SCREEN_UV, 0);
	
	vec4 final_render = blend2(near_render, far_render, depth);
	ALBEDO = near_render.rgb;
}