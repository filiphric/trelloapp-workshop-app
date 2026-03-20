/*!
  * core v9.9.1
  * (c) 2024 kazuya kawaguchi
  * Released under the MIT License.
  */
'use strict';

var coreBase = require('@intlify/core-base');

// register message compiler at @intlify/core
{
    coreBase.registerMessageCompiler(coreBase.compile);
}
// register message resolver at @intlify/core
coreBase.registerMessageResolver(coreBase.resolveValue);
// register fallback locale at @intlify/core
coreBase.registerLocaleFallbacker(coreBase.fallbackWithLocaleChain);

Object.keys(coreBase).forEach(function (k) {
  if (k !== 'default' && !Object.prototype.hasOwnProperty.call(exports, k)) exports[k] = coreBase[k];
});
