shader_type canvas_item;

const int MAX_RIPPLES = 10;  // Maximum number of ripples
const float SPEED = 0.2;
const float WAVE_WIDTH_FACTOR = 0.6;
const float DECAY_RATE = 0.5; // Rate at which the wave decays over time
const vec4 BASE_COLOR = vec4(.1, .3, .7, 1);


uniform vec2 ripple_centers[MAX_RIPPLES];
uniform float time_since_ripple[MAX_RIPPLES];
uniform vec2 viewport_size;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    float wave_pattern = 0.0;
	
	float aspect_ratio = viewport_size.y / viewport_size.x;
	bool found = false;
	COLOR = BASE_COLOR;
	for (int i = 0; i < ripple_centers.length(); i++) {
		if (abs(ripple_centers[i].x + 1.0) < 0.0001) {
			continue;
		}
		found = true;
		vec2 adjusted_uv = vec2(UV.x, UV.y * aspect_ratio);
		vec2 adjusted_center = vec2(ripple_centers[i].x, ripple_centers[i].y * aspect_ratio);
		float distance1 = distance(adjusted_uv, adjusted_center);
		
		// Calculate decay factor
        float decay = exp(-DECAY_RATE * time_since_ripple[i]);
		//float decay = 1.0;
		
		// Apply the decay to the amplitude
        float amplitude = 1.0 * decay;
		
		if (distance1 - (time_since_ripple[i] * SPEED) > 0.0) {
			wave_pattern += 0.0;
		} else {
			wave_pattern += sin((distance1 - (time_since_ripple[i] * SPEED)) * WAVE_WIDTH_FACTOR) * amplitude;
		}
	}
	if (found) {
		float perceived_brightness_change = log(1.0 + abs(wave_pattern)) * 20.0;
		if(wave_pattern > 0.0) {
			COLOR = BASE_COLOR * perceived_brightness_change;
		} else {
			COLOR = BASE_COLOR / perceived_brightness_change;
		}
		
		COLOR = clamp(COLOR, 0.0, 1.0); // Ensure values are within range
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
