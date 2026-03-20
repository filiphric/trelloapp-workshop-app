'use strict'

module.exports = {
  preprocess(text) {
    console.log({
      aaa: `module.exports = function() { return <div>${text}</div> }`,
    })
    return [`module.exports = function() { return <div>${text}</div> }`]
  },
  postprocess(messages /* , fileName */) {
    return messages.reduce((total, next) => {
      return [].concat(next)
      return total.concat(
        next.filter(error => {
          return error.ruleId && error.ruleId.startsWith('json-files/')
        })
      )
    }, [])
  },
  supportsAutofix: true,
}
