var webpack = require("webpack");
var cfg = {
	devtool: 'source-map',
	module: {
		loaders: [
			{ test: /\.coffee$/, use: "coffee-loader"},
			{ test: /\.(glsl|vert|frag)$/, use: "raw-loader" },
		]
	},
	entry: {
		main: "./source/main.coffee",
		tunnel: "./source/tunnel.coffee",
	},
	resolve: {
		"modules": ["node_modules"],
	},
	output: {
		path: __dirname+'/build',
		publicPath: '/build/',
		filename: "[name].js"
	},
	devServer: {
		port: 3002,
		compress: true
	}
}
module.exports = cfg;