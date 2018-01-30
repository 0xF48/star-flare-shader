precision mediump float;
uniform float iTime;

#define PI 3.14159265359
#define TWO_PI 6.28318530718
// #define SQ3 1.73205080757
// #define I_R 0.6
// #define F_R 9.6

varying vec2 v_uv;

// vec3 flare (float alpha,vec2 main, float seed,float dir){

// 	if(alpha < 0.001){
// 		return vec3(0.0);
// 	}
	
// 	float ang = atan(main.y, main.x);
// 	float t = iTime * .4 * dir;
// 	float amnt = -5.0+sin(seed+noise(seed))*0.6;
// 	float n = noise(vec2( (seed+ang*amnt+t*0.1) + cos(seed+alpha*10.5+t)*0.4+noise(seed),seed+t+ang));


// 	n *= pow(noise(vec2(seed*194.0+ ang*amnt+t + cos(seed+alpha*3.2*n+t*1.1+ang)*1.8,seed+t+ang)+alpha),4.0);
// 	n *= pow(noise(vec2(seed*134.0+ ang*amnt+t + sin(seed+alpha*2.0*n+t*1.1+ang)*1.1,seed+t+ang)+alpha),3.0);
// 	n *= pow(noise(vec2(seed*123.0+ ang*amnt+t + sin(seed+alpha*1.8*n+t*1.1+ang)*0.8,seed+t+ang)+alpha),2.0);
// 	n *= pow(alpha,3.5);
// 	n *= (ang+PI)/2.0 * (TWO_PI - ang - PI); //fade out flares at pole.
	
	
// 	n += sqrt(alpha * alpha * alpha * alpha) * 0.27;



// 	return vec3(pow(n*2.0,2.0),n,n);
// }

// void main() {
// 	vec2 pos = vec2(v_uv.x-0.5,v_uv.y-0.5)*4.0;
// 	vec3 c = vec3(0.0);
// 	float len = abs(length(pos));
// 	float alpha = pow(clamp(F_R - len + I_R,0.0,F_R)/F_R,len*20.0);


// 	c += flare(alpha,pos,74.621,1.0);
// 	c += flare(alpha,pos,35.1412,1.0);
// 	c += flare(alpha,pos,21.5637,1.0);
// 	c += flare(alpha,pos,1.2637,1.0);
	

// 	c = clamp(c,0.0,1.0);

// 	if(alpha >= 0.98){
// 		c -= (alpha- 0.98)*140.0;
// 	}
	
// 	gl_FragColor = vec4(c,1.0);
// }





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
	// f = alpha * f;
	// return alpha + f;
}

float flare(in float angle,in float alpha,in float time){
	float f = 0.0;
	float n = noise(vec2(time+angle+pow(alpha,0.5),time-angle+pow(alpha,0.5))*6.0);
	f += pow(1.0+sin((angle+sin(noise(time+angle*0.5)*10.0+time*30.0+pow(alpha*100.0,0.5))*0.01)*(60.0+n*0.4))*(1.0/2.0),4.0);
	f = alpha * f;
	return alpha + f;
}





#define SIZE 1.0
#define RADIUS 0.1
#define INNER_FADE 1.5
#define OUTER_FADE 0.08



#define ECLIPSE_SMOOTH 0.05



void main() {
	vec2 uv = vec2(v_uv.x-0.5,v_uv.y-0.5);
	float f = 0.0;
	float alpha = light(uv,SIZE,RADIUS,INNER_FADE,OUTER_FADE);
	float angle = atan(uv.y, uv.x);
	f += flare(angle,alpha,iTime*0.3);

	gl_FragColor = vec4(vec3(f),1.0);
}