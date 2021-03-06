#version 450
layout (location = 0) out vec4 outColor;

// uniforms
uniform int depth;
uniform dvec2 screenSize;
uniform dvec2 center;
uniform double zoom;
uniform int theme;

vec4 orangeTheme(float t);
vec4 blueTheme(float t);

void main()
{
    dvec2 z, c;
    c.x = double(screenSize.x / screenSize.y) * (gl_FragCoord.x / screenSize.x - 0.5);
    c.y = (gl_FragCoord.y / screenSize.y - 0.5);

    c /= zoom;
    c += center;

    double x, y;

    int i;
    for (i = 0; i < depth; ++i) {

        x = (z.x * z.x - z.y * z.y) + c.x;
        y = (z.y * z.x + z.x * z.y) + c.y;

		if(x * x + y * y > 4.0) {
            
            break;
        }
        else {
        
            z.x = x;
            z.y = y;
        }
    }
    
    if (theme == 0) {
    
        outColor = blueTheme(float(i) / float(depth));
    }
    else if(theme == 1) {
    
        outColor = orangeTheme(i);
    }
    else {
    
        outColor = vec4(0.0f);
    }
}

vec4 blueTheme(float t) {
    
    float r = 9.0 * (1.0 - t) * t * t * t;
    float g = 15.0 * (1.0 - t) * (1.0 - t) * t * t;
    float b = 8.5 * (1.0 - t) * (1.0 - t) * (1.0 - t) * t;

    return vec4(r, g, b, 1.0);
}

vec4 orangeTheme(float t) {

    if(t < depth) {

        float a = 10 * log(t) * 0.2f;
        return vec4((cos(a) + 1) * 0.5f, (cos(a + 2.1f) + 1.0f) * 0.5f, (cos(a + 4.2f) + 1.0f) * 0.5f, 1.0f);
    }
    else {
    
        return vec4(0.0f);
    }
}