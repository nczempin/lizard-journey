extern Image tileset;
extern float grid = 16.0;
extern vec2 size = vec2(256.0, 256.0);
extern float time = 0.0;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords) {
	vec4 m = Texel(texture, vec2(texture_coords.x, texture_coords.y));
	vec4 t = vec4(0.0);

	if(m.z == 0) {
		t = Texel(tileset,
			vec2(
				mod(texture_coords.x * (size.x / grid), (1.0 / grid)) + (1.0 / grid) * (m.x * 255.0),
				mod(texture_coords.y * (size.y / grid), (1.0 / grid)) + (1.0 / grid) * (m.y * 255.0)
			)
		);
	} else {
		t = Texel(tileset,
			vec2(
				mod(texture_coords.x * (size.x / grid), (1.0 / grid)) + (1.0 / grid) * ((m.x + mod(time, m.z * 255) * (1.0 / 255)) * 255.0),
				mod(texture_coords.y * (size.y / grid), (1.0 / grid)) + (1.0 / grid) * (m.y * 255.0)
			)
		);
	}

	return t;
}