shader_type canvas_item;

/* Makes character sprite white */
uniform float flashIntensity : hint_range(0.1,1.0) = 1;

void fragment() {
	vec4 color = texture(TEXTURE, UV); 
	color.rgb = mix(color.rgb, vec3(1,1,1).rgb, flashIntensity);
	COLOR = color;
}