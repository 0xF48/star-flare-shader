precision highp float;
uniform float iTime;
varying vec2 v_uv;

#define PI 3.14159265359
#define TWO_PI 6.28318530718


float random (in vec2 _st) { 
    return fract(sin(dot(_st.xy, vec2(12.9898,78.233))) * 43758.54531237);
}

float noise (in vec2 _st) {
    vec2 i = floor(_st);
    vec2 f = fract(_st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3. - 2.0 * f);

    return mix(a, b, u.x) + 
            (c - a)* u.y * (1. - u.x) + 
            (d - b) * u.x * u.y;
}


float light(in vec2 pos,in float size,in float radius,in float inner_fade,in float outer_fade){
    float len = length(pos/size);
    return pow(clamp((1.0 - pow( clamp(len-radius,0.0,1.0) , 1.0/inner_fade)),0.0,1.0),1.0/outer_fade);
}

float flare(in float angle,in float alpha,in float time){
    float t = time;
    float n = noise(vec2(t+angle+pow(alpha,0.5),t-angle+pow(alpha,0.5))*6.0);
    // float n = 0.5;
    
    float split = (10.0+sin(n*4.0+angle*20.0+alpha*4.0*n)*alpha*1.9);

    float rotate = sin(t*2.0+angle*10.0+alpha*20.0 + n*1.5)+angle*2.5*(1.5+0.2*n);
    
    
    float g = pow((2.0+sin(split+n*2.5*alpha+rotate)*1.4)*(1.0+n*3.5),0.1+n*(1.2-0.6*alpha));
    

    g *= pow((angle+PI)*(TWO_PI - angle - PI),0.45)*0.2; //fade out at pole 
    g *= alpha * alpha * alpha;
    g += alpha + g * g;
    return g;
}






#define SIZE 1.
#define RADIUS 0.09
#define INNER_FADE .81
#define OUTER_FADE 0.02
#define SPEED 0.2

#define BORDER 0.091


void main() {
    vec2 uv = -vec2(v_uv.x-0.5,v_uv.y-0.5);
    float f = 0.0;
    float f2 = 0.0;
    float t = iTime * SPEED;
    float alpha = light(uv,SIZE,RADIUS,INNER_FADE*1.5,OUTER_FADE*4.0);
    float angle = atan(uv.x,uv.y);
    float l = length(uv);
    if(l < BORDER){
        alpha = (1.0 - pow(((BORDER - l)*2.2/BORDER)*6.0,0.22)*0.68)+0.25;
        f = flare(angle,alpha*0.7,t)*1.8;
        f2 = flare(angle,alpha*1.3,((t+.5)*1.1))*0.5;
    }else if(alpha < 0.001){
        f = alpha;
    }else{
        f = flare(angle,alpha,t)*1.3;
    }
    gl_FragColor = vec4(vec3(f+f2*f2*f2,f*alpha+f2*f2*2.0,f*alpha*0.50+f2*1.6)*(.85),1.0);
}