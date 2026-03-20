/*!
  * core v9.9.1
  * (c) 2024 kazuya kawaguchi
  * Released under the MIT License.
  */
import { registerMessageCompiler, compile, registerMessageResolver, resolveValue, registerLocaleFallbacker, fallbackWithLocaleChain } from '@intlify/core-base';
export * from '@intlify/core-base';
import { getGlobalThis } from '@intlify/shared';

/**
 * This is only called in esm-bundler builds.
 * istanbul-ignore-next
 */
function initFeatureFlags() {
    if (typeof __INTLIFY_PROD_DEVTOOLS__ !== 'boolean') {
        getGlobalThis().__INTLIFY_PROD_DEVTOOLS__ = false;
    }
    if (typeof __INTLIFY_JIT_COMPILATION__ !== 'boolean') {
        getGlobalThis().__INTLIFY_JIT_COMPILATION__ = false;
    }
    if (typeof __INTLIFY_DROP_MESSAGE_COMPILER__ !== 'boolean') {
        getGlobalThis().__INTLIFY_DROP_MESSAGE_COMPILER__ = false;
    }
}

{
    initFeatureFlags();
}
// register message compiler for jit compilation
if (__INTLIFY_JIT_COMPILATION__) {
    registerMessageCompiler(compile);
}
// register message resolver at @intlify/core
registerMessageResolver(resolveValue);
// register fallback locale at @intlify/core
registerLocaleFallbacker(fallbackWithLocaleChain);
