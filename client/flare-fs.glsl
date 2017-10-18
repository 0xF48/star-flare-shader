varying vec2 vUv;
uniform float iTime;
uniform int ore_len;
uniform vec3 ore_arr[100];
uniform float cameraZoom;


#define PI 3.14159265359
#define TWO_PI 6.28318530718
#define SQ3 1.73205080757
#define SIZE 100.0
#define BG = 22.0/255.0
#define I_R 100.0
#define F_R 500.0


float random (in vec2 _st) { 
    return fract(sin(dot(_st.xy, vec2(12.9898,78.233))) * 43758.54531237);
}

// Based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
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



#define NUM_OCTAVES 3

float fbm ( in vec2 _st) {
    float v = 0.0;
    float a = 0.5;
    vec2 shift = vec2(20.0);
    // Rotate to reduce axial bias
    mat2 rot = mat2(cos(0.5), sin(0.5), 
                    -sin(0.5), cos(0.50));
    for (int i = 0; i < NUM_OCTAVES; ++i) {
        v += a * noise(_st);
        _st = rot * _st * 2.2 + shift;
        a *= 0.5;
    }
    return v;
}

vec4 energy_orb (vec2 uv, float alpha){
	vec2 st = uv * 0.1;
	vec3 color = vec3(0.);
	vec2 a = vec2(0.);
	vec2 b = vec2(0.);
	vec2 c = vec2(60.,800.);
	
	a.x = fbm( st);
	a.y = fbm( st + vec2(1.0));

	b.x = fbm( st + 4.*a);
	b.y = fbm( st);

	c.x = fbm( st + 17.0*b + vec2(10.7,.2)+ 1.2*iTime );
	c.y = fbm( st + 3.944*b + vec2(.3,12.8)+ 1.3*iTime);

	float f = fbm(st+c+b);


	color = mix(color, vec3(0.7,0.7,0.7), clamp(length(c.x),0.8, 0.9));


	vec4 finalColor = vec4(f*1.9*color,1.0);
	finalColor += pow(alpha/(I_R*0.9),1.5);
	return finalColor;
}



vec4 flare (float alpha,vec2 main, float seed,float dir){

	if(alpha < 0.001){
		return vec4(0.0);
	}
	

	float amnt = 0.6+sin(seed)*8.0;
	float ang = atan(main.y, main.x);
	float t = iTime * .6 * dir;
	float n = noise(vec2( (seed+ang*amnt+t*0.1) + cos(alpha*13.8+noise(t+ang+seed)*3.0)*0.2+seed/20.0,seed+t+ang));


	n *= pow(noise(vec2(seed*194.0+ ang*amnt+t + cos(alpha*2.0*n+t*1.1+ang)*2.8,seed+t+ang)+alpha),2.0);
	n *= pow(noise(vec2(seed*134.0+ ang*amnt+t + cos(alpha*2.2*n+t*1.1+ang)*1.1,seed+t+ang)+alpha),3.0);
	n *= pow(noise(vec2(seed*123.0+ ang*amnt+t + cos(alpha*2.3*n+t*1.1+ang)*0.8,seed+t+ang)+alpha),4.0);
	n *= pow(alpha,2.6);
	n *= (ang+PI)/2.0 * (TWO_PI - ang - PI); //fade out flares at pole.
	
	
	n += sqrt(alpha * alpha) * 0.26;

	float g = 0.01;

	return vec4(pow(n*2.0,2.0)+g,n+g,n+g,n+g);
}



void main() {
	vec2 center = vec2(.0);
	vec4 c = vec4(0.0);
	vec2 main = vUv-center;
	float len = length(main);
	float alpha = pow(clamp(F_R - len + I_R-40.0,0.0,F_R)/F_R,6.0);



	c += flare(alpha,main,74.621,1.0);
	c += flare(alpha,main,35.1412,1.0);
	c += flare(alpha,main,21.5637,1.0);
	c += flare(alpha,main,1.2637,1.0);
	
	// if(alpha >= 0.99){
	// 	c += energy_orb(vUv,len);
	// }
	// c.xy += alpha * alpha;
	
	c.w = clamp(c.w,0.0,1.0);

	if(alpha >= 0.98){
		c.w -= (alpha- 0.98)*140.0;
		
	}
	
	gl_FragColor = c;
}