shader_type canvas_item;

uniform bool use_grayscale = true;
uniform vec4 shift_color: source_color;
uniform sampler2D affectedHues : source_color;

vec3 rgb2hsv(vec3 rgb) {
	float r = rgb.r;
	float g = rgb.g;
	float b = rgb.b;
	float max_val = max(r, max(g, b));
	float min_val = min(r, min(g, b));
	float delta = max_val - min_val;
	float h = 0.0;
	float s = 0.0;
	float v = max_val;
	
	if (delta > 0.0001) {
		s = delta / max_val;
		if (abs(r - max_val) < 0.0001)      h = (g - b) / delta;
		else if (abs(g - max_val) < 0.0001) h = 2.0 + (b - r) / delta;
		else                                h = 4.0 + (r - g) / delta;
		h *= 60.0;
		if (h < 0.0) h += 360.0;
	}
	return vec3(h, s, v);
}

void fragment() {
	vec3 hsl = rgb2hsv(COLOR.rgb);
	float hue = hsl.x;
	float mixRatio = texture(affectedHues, vec2(hue / 360.0, 0.0)).x;
	
	vec3 newColor = COLOR.rgb;
	newColor = mix(newColor, vec3(0.299 * COLOR.r + 0.587 * COLOR.g + 0.114 * COLOR.b), float(use_grayscale));
	newColor *= shift_color.xyz;
	
	COLOR.rgb = mix(COLOR.rgb, newColor, mixRatio);
	
}