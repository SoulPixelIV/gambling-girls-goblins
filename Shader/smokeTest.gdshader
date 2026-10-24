shader_type canvas_item;
render_mode unshaded; //No Light Influence

//Background Color
uniform vec4 background_color : source_color =
    vec4(0.008, 0.001, 0.006, 1.0);

//Smoke Colors
uniform vec4 smoke_dark : source_color =
    vec4(0.30, 0.005, 0.075, 1.0);

uniform vec4 smoke_mid : source_color =
    vec4(0.85, 0.008, 0.22, 1.0);

uniform vec4 smoke_bright : source_color =
    vec4(1.0, 0.035, 0.36, 1.0);

uniform float speed : hint_range(0.0, 0.5) = 0.06; //0.06
uniform float scale : hint_range(1.0, 8.0) = 2.3; //2.3 fills whole screen perfectly
uniform float distortion : hint_range(0.0, 1.0) = 0.32;
uniform float density : hint_range(0.1, 1.0) = 0.55;
uniform float height : hint_range(0.2, 1.0) = 0.72;
uniform float softness : hint_range(0.01, 0.3) = 0.12;
uniform float brightness : hint_range(0.2, 2.0) = 1.0;

//Generate Random Values
float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x / max(abs(p.y), 0.001));
}

//Generate Noise
float noise(vec2 p) {
	//Position
    vec2 i = floor(p);
    vec2 f = fract(p);

	//Quintische Interpolation
    f = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);

	//Calculate Corner Pixels
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));

    return mix(
        mix(a, b, f.x),
        mix(c, d, f.x),
        f.y
    );
}

//Smoke Noise
float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;

    for (int i = 0; i < 4; i++) {
        value += noise(p) * amplitude;
        p = p * 2.0 + vec2(17.1, 9.2);
        amplitude *= 0.5;
    }
    return value;
}

//Smoke Noise Part 2
void fragment() {
    //Pixelate Smoke
    float pixel_size = 6.0; //12.0 with Blur || 6.0 with NO Blur

    vec2 uv = UV;
    uv = floor(uv / SCREEN_PIXEL_SIZE / pixel_size)
        * SCREEN_PIXEL_SIZE * pixel_size;

    //Smoke Scale
    vec2 p = uv;
    p.x *= 1.6; //Horizontal Scaling
	p.y *= 0.7; //Vertical Scaling

	//Animation Speed
    float t = TIME * speed;

    // Organische Verzerrung
    vec2 warp;

    warp.x = fbm(
        p * scale + vec2(2.4, -t * 0.45)
    );

    warp.y = fbm(
        p * scale + vec2(8.2, t * 0.3)
    );

    vec2 q = p * scale;
    q += (warp - 0.5) * distortion * 3.0;

    // Große Rauchwolken
    float broad = fbm(
        q + vec2(3.1, t)
    );

    // Mittlere Strukturen
    float detail = fbm(
        q * 2.3 + vec2(-4.0, t * 1.2)
    );

    // Kleine, feine Rauchdetails
    float fine = fbm(
        q * 4.1 + vec2(7.3, -t * 0.8)
    );

    // Alle Ebenen kombinieren
    float smoke = broad * 0.60
                + detail * 0.27
                + fine * 0.13;

    // Weiche Rauchmaske
    float cloud = smoothstep(
        0.30 - density * 0.15 - softness,
        0.82 + softness,
        smoke
    );

    // Rauch steigt vom unteren Rand auf
    float bottom_fade = smoothstep(
        1.0 - height,
        0.98,
        uv.y
    );

    // Unregelmäßige, ausgefranste Oberkante
    float tendrils = smoothstep(
        0.32,
        0.68,
        broad + (warp.y - 0.5) * 0.35
    );

    float upper_edge = mix(
        0.25,
        1.0,
        tendrils
    );

    float mask = cloud * bottom_fade * upper_edge;
    mask = clamp(mask, 0.0, 1.0);

    // Pinker Farbverlauf
    vec3 smoke_color = mix(
        smoke_dark.rgb,
        smoke_mid.rgb,
        smoothstep(0.25, 0.72, smoke)
    );

    smoke_color = mix(
        smoke_color,
        smoke_bright.rgb,
        smoothstep(0.62, 0.85, smoke) * 0.65
    );

    // Helle Bereiche dezent verstärken
    float glow = smoothstep(
        0.45,
        0.8,
        smoke
    );

    smoke_color *= brightness * (
        0.75 + glow * 0.5
    );

    // Rauch und schwarzen Hintergrund mischen
    vec3 final_color = mix(
        background_color.rgb,
        smoke_color,
        mask
    );

    COLOR = vec4(final_color, 1.0);
}
