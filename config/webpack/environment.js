const { environment } = require('@rails/webpacker')
const vuxLoader = require('vux-loader')

// module.exports = environment

module.exports = vuxLoader.merge(environment, {
  plugins: ['vux-ui']
})
