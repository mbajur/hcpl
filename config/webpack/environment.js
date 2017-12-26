const { environment } = require('@rails/webpacker')
const vuxLoader = require('vux-loader')

// module.exports = environment

console.log('-----> DEBUG:')
// console.log(environment)
console.log(environment.plugins)
environment.plugins.push({})

module.exports = vuxLoader.merge(environment, {
  plugins: ['vux-ui']
})
