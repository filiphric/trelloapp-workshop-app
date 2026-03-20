'use strict'

var espree = require('espree')
var unified = require('unified')
var rehype = require('rehype-parse')

exports.parseForESLint = function(code) {
  return {
    // ast: unified()
    //   .use(rehype)
    //   .parse(code),
    ast: espree.parse(code),
    services: {},
    scopeManager: null,
    visitorKeys: null,
  }
}
// function parse(code) {
//   return parseForESLint(code).ast
// }

// modules.export = {
//   parse,
//   parseForESLint,
// }
