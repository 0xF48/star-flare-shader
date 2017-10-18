var webpack = require("webpack");
var path = require('path')
// var V8LazyParseWebpackPlugin = require('v8-lazy-parse-webpack-plugin');
const ENV = process.env.NODE_ENV || 'development';
console.log('env: ',ENV);
var path = require('path');

var cfg = {
	devtool: 'source-map',
	module: {
		loaders: [
			{ test: /\.coffee$/, use: "coffee-loader"},
			{ test: /\.json$/, use: 'json-loader'},
			{ test: /\.(glsl|vert|frag)$/, use: "raw-loader" },
			{ test: /\.(scss|less)$/, use: ['style-loader','css-loader','sass-loader'] }
			// { test: /\.css$/, use: 'style-loader!css-loader!postcss-loader' },
		]
	},
	entry: {
		main: __dirname+"/client/main.coffee",
	},

	resolve: {
		"modules": ["node_modules","shared_modules"],
		"alias": {

			"shared_modules":__dirname+'/shared_modules',
			"intui" : __dirname+"/client/lib/intui",
			"react" : "preact-compat",
			"react-dom": "preact-compat",
			"re": "preact"
		}
		// enforceModuleExtension: true
	},
	output: {
		path: __dirname+'/build',
		publicPath: __dirname+'/build',
		filename: "[name].js"
	},
	plugins: [
		new webpack.DefinePlugin({
		   'process.env.NODE_ENV': JSON.stringify(ENV)
		}),
	]
}




module.exports = cfg;
