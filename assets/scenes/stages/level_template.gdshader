shader_type canvas_item;

uniform vec4 C1 : source_color;
uniform vec4 C2 : source_color;
uniform vec4 C3 : source_color;
uniform float alpha = 1.0;

void fragment(){
    vec4 t = texture(TEXTURE, UV);
    vec4 color = floor(t.rgba * 255.0);
    if (color == vec4(255, 255, 255, 255)) {
        COLOR = C1;
	} else if (color == vec4(255, 0, 0, 255)) {
        COLOR = C2;
	} else if (color == vec4(0, 0, 0, 255)) {
        COLOR = C3;
    } else {
        COLOR = t;
    }
	if (COLOR.a != 0.0) {
		COLOR.a = alpha;
	}
	
}