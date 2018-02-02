precision mediump float;
uniform float iTime;

#define PI 3.14159265359
#define TWO_PI 6.28318530718
// #define SQ3 1.73205080757
// #define I_R 0.6
// #define F_R 9.6

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

float noise (float _st) {
    return fract(abs(sin(_st)));
}

float light(in vec2 pos,in float size,in float radius,in float inner_fade,in float outer_fade){
	float len = length(pos/size);
	return pow(clamp((1.0 - pow( clamp(len-radius,0.0,1.0) , 1.0/inner_fade)),0.0,1.0),1.0/outer_fade);
}

float flare(in float angle,in float alpha,in float time){
	float t = time*0.3;
	float n = noise(vec2(t+angle+pow(alpha,0.5),t-angle+pow(alpha,0.5))*6.0);
	// float n = 0.5;
	
    float split = angle*(10.0+sin(t*10.0+n*5.0+angle*15.0+alpha*2.0*n)*0.5);
	
    float rotate = sin(t+alpha*20.0 + n*1.5)+angle*9.5*(1.5+0.2*n);
	
    
    float g = pow((2.0+sin(split+n*4.0*alpha+rotate)*1.4)*(1.0+n*4.0),n*1.8);
	

	g *= pow(((angle+PI) * (TWO_PI - angle - PI)),1.2)*0.01; //fade out at pole	
	g *= alpha * alpha * alpha;
	g += alpha + g * 0.7;
	return g;
}





#define SIZE 1.0
#define RADIUS 0.1
#define INNER_FADE .81
#define OUTER_FADE 0.02



#define ECLIPSE_SMOOTH 0.05




void main() {
	vec2 uv = vec2(v_uv.x-0.5,v_uv.y-0.5);
	float f = 0.0;
	float alpha = light(uv,SIZE,RADIUS,INNER_FADE*1.5,OUTER_FADE*4.0);
	float angle = atan(uv.x,uv.y);
	
	if(alpha >= 0.999){
		alpha = (1.0 - light(uv,SIZE,0.0,INNER_FADE*0.725,OUTER_FADE))*1.8;
		f = flare(angle,alpha*0.7,iTime+0.5);
        f *= 1.1;
	}else if(alpha < 0.001){
		f = alpha;
	}else{
		f = flare(angle,alpha,iTime)*1.8;
	}
	gl_FragColor = vec4(vec3(f,f*alpha,alpha),1.0);
}