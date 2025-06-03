const path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = {
  mode: "development",
  entry: "./src/index.mjs",
  output: {
    filename: "bundle.js",
    path: path.resolve(__dirname, "dist"),
    clean: true,
    publicPath: './'
  },
  devtool: "eval-source-map",
  devServer: {
    static: "./dist",
    watchFiles: ["src/**/*"],
    open: true,
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: "./src/index.html",
    }),
    new HtmlWebpackPlugin({
      template: "./src/tutorial.html",
      filename: "tutorial.html",
    }),
     new CopyWebpackPlugin({
      patterns: [
        { from: 'src/Game/Tacogotchi.zip', to: 'Game/Tacogotchi.zip' },
        { from: 'src/Game/Tacogotchi.dmg.zip', to: 'Game/Tacogotchi.dmg.zip' }
      ]
    })
  ],
  module: {
    rules: [
      {
        test: /\.css$/i,
        use: ["style-loader", "css-loader"],
      },
      {
        test: /\.(png|svg|jpg|jpeg|gif)$/i,
        type: "asset/resource", // <-- handles images
      },
    ],
  },
};