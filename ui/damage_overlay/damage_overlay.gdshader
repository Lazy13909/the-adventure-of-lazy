shader_type canvas_item;

// Colors and dials we can change from the Inspector or from code.
uniform vec4 blotch_color : source_color = vec4(0.6, 0.0, 0.0, 1.0);
uniform float flash_strength : hint_range(0.0, 1.0) = 0.0;     // temporary flash on damage
uniform float permanent_strength : hint_range(0.0, 1.0) = 0.0; // for the Screamer scar later
uniform float noise_scale = 3.0;

// A pseudo-random number between 0 and 1 for a given 2D point.
// Same input always gives the same output.
float rand(vec2 p) {
	return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}


// Smooth noise: blends the random values of the four surrounding grid corners.
float value_noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	
	float a = rand(i);
	float b = rand(i + vec2(1.0, 0.0));
	float c = rand(i + vec2(0.0, 1.0));
	float d = rand(i + vec2(1.0, 1.0));
	
	vec2 u = f * f * (3.0 - 2.0 * f); // smooth the blending
	
	return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Layers of noise at different sizes, so blotches look organic.
float fbm(vec2 p) {
	float value = 0.0;
	float amplitude = 0.5;
	for (int i = 0; i < 4; i++) {
		value += amplitude * value_noise(p);
		p *= 2.0;
		amplitude *= 0.5;
	}
	return value;
}

void fragment() {
	// Correct for screen shape so blotches are not stretched.
	float aspect = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
	vec2 uv = vec2(UV.x * aspect, UV.y);

	float noise = fbm(uv * noise_scale);

	// 0 in the screen center, 1 near the corners.
	float edge = smoothstep(0.25, 0.85, distance(UV, vec2(0.5)) * 1.4);

	// Flash: whole screen, but stronger near the edges.
	// As flash_strength grows, the threshold drops, so blotches spread.
	float flash_field = noise * 0.7 + edge * 0.5;
	float threshold = 1.0 - flash_strength;
	float flash_alpha = smoothstep(threshold, threshold + 0.25, flash_field) * flash_strength;

	// Permanent scar: edges only.
	float perm_field = noise * 0.5 + edge * 0.8;
	float perm_alpha = smoothstep(0.55, 0.9, perm_field) * permanent_strength * 0.7;

	float alpha = max(flash_alpha, perm_alpha);
	COLOR = vec4(blotch_color.rgb, clamp(alpha, 0.0, 0.8)); // cap so the game stays visible
}
