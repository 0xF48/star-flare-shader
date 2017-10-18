varying vec2 vUv;


void main()
{
	vUv = uv;
	vec4 pos = vec4( position, 1.0 );
	vec4 mvPosition = modelViewMatrix * pos;
	gl_Position = projectionMatrix * mvPosition;
}