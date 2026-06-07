shader_type canvas_item;

uniform highp vec2 offset;
uniform highp float speed : hint_range(0, 1) = 1.0;

// 👉 Rarity
uniform float rarity_strength : hint_range(0.0, 2.0) = 1.0;

// ✨ NEW: Sparkle control
uniform float sparkle_strength : hint_range(0.0, 2.0) = 2.0;

vec4 effect(sampler2D tex, vec2 texture_coords) {
    vec4 texel = texture(tex, texture_coords);
    vec2 uv = texture_coords;

    vec2 adjusted_uv = uv - vec2(0.5);

    float low = min(texel.r, min(texel.g, texel.b));
    float high = max(texel.r, max(texel.g, texel.b));
    float delta = (high - low);

    vec2 foil = vec2(TIME / (1.0 / speed) + offset.x, offset.y);

    float fac = clamp(
        2.0 * sin(
            (length(90.0 * adjusted_uv) + foil.r * 2.0)
            + 3.0 * (1.0 + 0.8 * cos(length(113.1121 * adjusted_uv) - foil.r * 3.121))
        )
        - 1.0
        - max(5.0 - length(90.0 * adjusted_uv), 0.0),
    0.0, 1.0);

    vec2 rotater = vec2(cos(foil.r * 0.1221), sin(foil.r * 0.3512));
    float angle = dot(rotater, adjusted_uv) / (length(rotater) * length(adjusted_uv) + 0.0001);

    float fac2 = clamp(
        5.0 * cos(
            foil.g * 0.3
            + angle * 3.14 * (2.2 + 0.9 * sin(foil.r * 1.65 + 0.2 * foil.g))
        )
        - 4.0
        - max(2.0 - length(20.0 * adjusted_uv), 0.0),
    0.0, 1.0);

    float fac3 = 0.3 * sin(foil.r * 5.0 + uv.x * 3.0 + 3.0 * (1.0 + 0.5 * cos(foil.r * 7.0)));
    float fac4 = 0.3 * sin(foil.r * 6.66 + uv.y * 3.8 + 3.0 * (1.0 + 0.5 * cos(foil.r * 3.414)));

    float maxfac = max(max(fac, fac2), max(fac3, fac4));

    // ----------------------------
    // BASE + FOIL
    // ----------------------------

    vec3 base = texel.rgb + 0.03;

    vec3 foil_color = vec3(0.25, 0.45, 1.0);

    float rarity = pow(rarity_strength, 2.2);

    float raw_intensity = maxfac * (0.6 + delta) * rarity;
    float intensity = raw_intensity * (1.0 + rarity * 0.8);

    base += foil_color * intensity * 1.6;
    base = mix(base, base * (1.0 + intensity), 0.6);

    // --------------------------------
    // ✨ SPARKLE EFFECT (NEW)
    // --------------------------------

    if (sparkle_strength > 0.0) {

        // pseudo-random grid sparkle
        vec2 grid = floor(uv * 80.0);
        float rand = fract(sin(dot(grid, vec2(12.9898, 78.233))) * 43758.5453);

        float sparkle = step(0.98, rand); // rare points only

        // shimmer over time
        sparkle *= (0.5 + 0.5 * sin(TIME * 6.0 + rand * 100.0));

        // fade by rarity + intensity
        sparkle *= (0.3 + rarity);
        sparkle *= sparkle_strength;

        vec3 sparkle_color = vec3(1.0, 1.0, 1.0);

        base += sparkle_color * sparkle * 1.5;
    }

    texel.rgb = base;

    texel.a = clamp(texel.a * (0.8 + maxfac * 0.4), 0.0, 1.0);

    return texel;
}

void fragment() {
    COLOR *= effect(TEXTURE, UV);
}