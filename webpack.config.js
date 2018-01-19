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
		main: __dirname+"/client/main.coffee",
	},
	resolve: {
		"modules": ["node_modules"],
	},
	output: {
		path: __dirname+'/build',
		publicPath: __dirname+'/build',
		filename: "[name].js"
	},
}
module.exports = cfg;