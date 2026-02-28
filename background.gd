extends Material

uniform vec2 tiling = vec2(1.0, 1.0);
uniform vec2 offset = vec2(0.0, 0.0);

uniform vec4 light_color : source_color = vec4(1, 1, 1, 1);
uniform vec4 dark_color  : source_color = vec4(0, 0, 0.8, 1.0);

void vertex() {
	// Called for every vertex the material is visible on.
	UV = UV * tiling + offset * TIME;
}

void fragment() {
	float mask = texture(TEXTURE, UV).r;

	// Mix between two blues
	vec3 color = mix(dark_color.rgb, light_color.rgb, mask);

	COLOR = vec4(color, 1.0);
}
