'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

const vueDemi = require('vue-demi');
const pinia = require('pinia');

function createTestingPinia({
  initialState = {},
  plugins = [],
  stubActions = true,
  stubPatch = false,
  fakeApp = false,
  createSpy: _createSpy
} = {}) {
  const pinia$1 = pinia.createPinia();
  pinia$1._p.push(({ store }) => {
    if (initialState[store.$id]) {
      mergeReactiveObjects(store.$state, initialState[store.$id]);
    }
  });
  plugins.forEach((plugin) => pinia$1._p.push(plugin));
  pinia$1._p.push(WritableComputed);
  const createSpy = _createSpy || typeof jest !== "undefined" && jest.fn || typeof vi !== "undefined" && vi.fn;
  if (!createSpy) {
    throw new Error("[@pinia/testing]: You must configure the `createSpy` option.");
  }
  pinia$1._p.push(({ store, options }) => {
    Object.keys(options.actions).forEach((action) => {
      store[action] = stubActions ? createSpy() : createSpy(store[action]);
    });
    store.$patch = stubPatch ? createSpy() : createSpy(store.$patch);
  });
  if (fakeApp) {
    const app = vueDemi.createApp({});
    app.use(pinia$1);
  }
  pinia$1._testing = true;
  pinia.setActivePinia(pinia$1);
  Object.defineProperty(pinia$1, "app", {
    configurable: true,
    enumerable: true,
    get() {
      return this._a;
    }
  });
  return pinia$1;
}
function mergeReactiveObjects(target, patchToApply) {
  for (const key in patchToApply) {
    if (!patchToApply.hasOwnProperty(key))
      continue;
    const subPatch = patchToApply[key];
    const targetValue = target[key];
    if (isPlainObject(targetValue) && isPlainObject(subPatch) && target.hasOwnProperty(key) && !vueDemi.isRef(subPatch) && !vueDemi.isReactive(subPatch)) {
      target[key] = mergeReactiveObjects(targetValue, subPatch);
    } else {
      if (vueDemi.isVue2) {
        vueDemi.set(target, key, subPatch);
      } else {
        target[key] = subPatch;
      }
    }
  }
  return target;
}
function isPlainObject(o) {
  return o && typeof o === "object" && Object.prototype.toString.call(o) === "[object Object]" && typeof o.toJSON !== "function";
}
function isComputed(v) {
  return !!v && vueDemi.isRef(v) && "effect" in v;
}
function WritableComputed({ store }) {
  const rawStore = vueDemi.toRaw(store);
  for (const key in rawStore) {
    const value = rawStore[key];
    if (isComputed(value)) {
      rawStore[key] = vueDemi.customRef((track, trigger) => {
        let internalValue;
        return {
          get: () => {
            track();
            return internalValue !== void 0 ? internalValue : value.value;
          },
          set: (newValue) => {
            internalValue = newValue;
            trigger();
          }
        };
      });
    }
  }
}

exports.createTestingPinia = createTestingPinia;
