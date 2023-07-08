shader_type spatial;
render_mode unshaded;

uniform sampler2D refraction_map;

uniform vec4 water_tint : source_color = vec4(0.2, 0.6, 1.0, 0.1);

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

varying vec2 globalposition;

void vertex(){
	globalposition = (MODEL_MATRIX * vec4(VERTEX, 0.0)).xy;
}


void fragment()
{

}