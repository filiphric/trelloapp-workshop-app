'use strict'

const traverse = require('traverse')
var svelte = require('svelte/compiler')
var babel = require('babel-eslint')
const walk = require('svelte-markup-walker').default
class SourceLocation {
  line = 1
  column = 0
}
exports.parseForESLint = function(code, options) {
  // console.log(JSON.stringify(babel.parse(code, options), null, 2))
  // console.log(svelte.parse(code, options).html)
  const ast = svelte.parse(code, options).html

  ast.range = [ast.start, ast.end]

  ast.comments = []
  ast.tokens = []

  traverse(ast).forEach(function(node) {
    if (node && typeof node.start === 'number' && this.key !== 'loc') {
      this.update({
        loc: {
          start: {
            line: 1,
            column: node.start,
          },
          end: {
            line: 1,
            column: node.end,
          },
          // start: new SourceLocation(),
          // end: new SourceLocation(),
        },
        ...node,
      })
    }
  })
  // walk({
  //   html({content, filename}) {
  //     return {
  //       enter(node) {
  //         node.loc = {
  //           start: node.start,
  //           end: node.end,
  //         }
  //         return node
  //       },
  //     }
  //   },
  // }).markup({
  //   content: code,
  //   filename: 'file.svelte',
  // })

  console.log(ast.range)

  return {
    // ast: babel(code, options)
    // ...babel.parseForESLint(code),
    ast,
    // ast: {
    //   type: 'Program',
    //   comments: [],
    //   tokens: [],
    //   root: ast,
    //   loc: ast.loc,
    //   range: ast.range,
    //   value: '',
    //   // value: code.substr(ast.range[0], ast.range[1] - ast.range[0]),
    // },
    services: {},
    // scopeManager: null,
    visitorKeys: {
      Program: ['root'],
      Fragment: ['children'],
      Element: ['name', 'attributes,', 'children'],
      Attribute: ['name', 'value'],
      Text: ['data', 'raw'],
    },
  }
}
exports.parse = function(code) {
  return exports.parseForESLint(code).ast
}

// modules.export = {
//   parse,
//   parseForESLint,
// }
