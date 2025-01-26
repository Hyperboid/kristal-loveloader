uniform float amount = .5;

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    vec2 coords = texture_coords;
    vec4 pixcolor = Texel(texture, coords);
    float alpha = pixcolor.a;
    float luma = (pixcolor.r + pixcolor.g + pixcolor.b) / 3;
    vec4 greyver = vec4(luma,luma,luma,alpha);
    vec4 lerped = (pixcolor * (1-amount)) + (greyver * amount);
    return lerped * color;
}
