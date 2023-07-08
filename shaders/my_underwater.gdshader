shader_type spatial;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D depth_texture : hint_depth_texture, repeat_disable, filter_nearest;


varying mat4 CAMERA;

void vertex() {
	CAMERA = INV_VIEW_MATRIX;
}

void fragment() {
	float view_distance = 30.0f;
	
	float depth = texture(depth_texture, SCREEN_UV).x;
	vec3 ndc = vec3(SCREEN_UV, depth) * 2.0 - 1.0;
	vec4 world = CAMERA * INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	vec3 world_position = world.xyz / world.w;
	
	ALBEDO = vec3(mix(1, 0, world_position.z / view_distance));
}

