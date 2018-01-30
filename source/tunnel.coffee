{Box,Shader} = require 'shader-box'




window.box = new Box
	grid: [1,1]
	canvas: window.canvas
	resize: true
	context:
		antialias: false
		depth: false


flare = new Shader
	code: require('./tunnel.glsl').default
	uniforms: 
		iTime:
			type:'1f'
			val:0


box.add(flare)


tick = (t)->
	requestAnimationFrame(tick)
	flare.uniforms.iTime.val = t/2e3
	box
		.clear()
		.draw(flare)


tick(0)