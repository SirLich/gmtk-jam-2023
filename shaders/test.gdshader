shader_type spatial;
render_mode unshaded;

uniform sampler2D depth_texture : source_color, hint_depth_texture;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;

uniform vec4 near_tint : source_color = vec4(0.4, 0.6, 1, 0.2);
uniform vec4 far_tint : source_color = vec4(0.0, 0.1, 1.0, 0.1);
uniform vec4 end_tint : source_color = vec4(0.4, 0.6, 1, 0.2);

uniform float background_blur = 6.0;
uniform float view_distance = 50.0f;
uniform float end_distance = 50.0f;

uniform float size;


varying mat4 CAMERA;

vec4 blend(vec4 first, vec4 second, float factor){
	return mix(second, first, factor);
}

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
	CAMERA = INV_VIEW_MATRIX;
}

void fragment() {
	vec2 MY_UV = SCREEN_UV;
	
	float X = MY_UV.x*25.+TIME;
	float Y = MY_UV.y*25.+TIME;
	MY_UV.y += cos(X+Y)*0.005*cos(Y);
	MY_UV.x += sin(X-Y)*0.005*sin(Y);

	float depth_tex = texture(depth_texture, SCREEN_UV).x;
	vec3 ndc = vec3(MY_UV * 2.0 - 1.0, depth_tex);
	vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z;
	
	float depth = mix(1, 0, linear_depth / view_distance);
	depth = clamp(depth, 0, 1);
	
	float end_depth = mix(1, 0, linear_depth / end_distance);
	end_depth = clamp(end_depth, 0, 1);
	
	vec4 world = CAMERA * INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	vec3 world_position = world.xyz / world.w;
	
	vec4 far_render = textureLod(screen_texture, MY_UV, background_blur);
	far_render = far_render * far_tint;
	
	vec4 near_render = textureLod(screen_texture, SCREEN_UV, 0);
	near_render = near_render * near_tint;
	
	vec4 final_render = blend(near_render, far_render, depth);
	
	final_render = blend(final_render, end_tint, end_depth);
	
	float dis = 0.8 - length(UV - vec2(0.5)) - 0.2;
	
	
	final_render = final_render * dis;
	
	ALBEDO = final_render.rgb;
	
//	ALBEDO = vec3(dis);
}
