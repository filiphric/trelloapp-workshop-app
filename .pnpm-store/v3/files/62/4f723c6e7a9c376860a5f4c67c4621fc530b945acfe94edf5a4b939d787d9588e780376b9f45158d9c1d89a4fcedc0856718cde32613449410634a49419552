const { TsconfigPathsPlugin } = require('tsconfig-paths-webpack-plugin');

module.exports = (api, options) => {
  api.chainWebpack(config => {
    config.resolve
      .plugin('tsconfig-paths')
      .use(TsconfigPathsPlugin)
  });
}
