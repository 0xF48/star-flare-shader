window.THREE = require 'three'



default_vs = require('./default-vs.glsl').default
flare_fs = require('./flare-fs.glsl').default

canvas = window.canvas
width = window.innerWidth
height = window.innerHeight
radius = if width < height then width/2 else height/2
aspect = window.innerWidth/window.innerHeight
frustumSize = radius
camera = new THREE.OrthographicCamera( frustumSize * aspect / - 2, frustumSize * aspect / 2, frustumSize / 2, frustumSize / - 2, 1, frustumSize )
camera.position.z = 100
cameraViewProjectionMatrix = new THREE.Matrix4();
renderer = new THREE.WebGLRenderer
	canvas: canvas
	antialias: no
	depth : no
	logarithmicDepthBuffer : no
	precision: "lowp"

renderer.shadowMap.type = THREE.BasicShadowMap
renderer.setPixelRatio( window.devicePixelRatio )

renderer.setClearColor('#000')



scene = new THREE.Scene
mesh = new THREE.Mesh



geom = new THREE.PlaneBufferGeometry(radius*2,radius*2)

uvs = [
	-radius, radius
	radius,radius
	-radius,-radius
	radius,-radius
]
geom.addAttribute('uv',new THREE.Float32BufferAttribute(uvs,2))



uniforms = 
	iTime:
		type:'f'
		value:0


mat = new THREE.ShaderMaterial
	uniforms: uniforms
	vertexShader: default_vs
	fragmentShader: flare_fs
	transparent: true

mesh = new THREE.Mesh geom,mat
scene.add mesh


updateSize = ()->
	width = window.innerWidth
	height = window.innerHeight

	camera.aspect =  width/height
	renderer.setSize width,height 
	camera.updateProjectionMatrix()
updateSize()

tick = (t)->
	# uniforms.hue.value = Math.abs(Math.sin(t))
	uniforms.iTime.value = t/2e3
	renderer.render(scene,camera)
	requestAnimationFrame(tick)

		
tick()
