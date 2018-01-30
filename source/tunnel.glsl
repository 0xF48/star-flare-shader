precision mediump float;
uniform float iTime;

#define PI 3.14159265359
#define TWO_PI 6.28318530718


varying vec2 v_uv;
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

float noise (float _st) {
    return fract(abs(sin(_st)));
}

float light(in vec2 pos,in float size,in float radius,in float inner_fade,in float outer_fade){
	float len = length(pos/size);
	return pow(clamp((1.0 - pow( clamp(len-radius,0.0,1.0) , 1.0/inner_fade)),0.0,1.0),1.0/outer_fade);
}

float f2(in float angle,in float alpha,in float time){
	return noise(vec2(time+angle+alpha,time-angle+alpha)*30.0);
}

float flare(in float angle,in float alpha,in float time){
	float ff = f2(angle,alpha,time);
	float ff2 = f2(angle,alpha+0.1,time);
	float f = noise(vec2(time+ff+ff2,time-ff+alpha)*20.0);
	f = alpha * f;
	return alpha + f;
}



#define SIZE 1.0
#define RADIUS 0.1
#define INNER_FADE 1.5
#define OUTER_FADE 0.15



#define ECLIPSE_SMOOTH 0.05



void main() {
	vec2 uv = vec2(v_uv.x-0.5,v_uv.y-0.5);
	float f = 0.0;
	float alpha = light(uv,SIZE,RADIUS,INNER_FADE,OUTER_FADE);
	float angle = atan(uv.y, uv.x);
	f += flare(angle,alpha,iTime*0.3);

	gl_FragColor = vec4(vec3(f),1.0);
}