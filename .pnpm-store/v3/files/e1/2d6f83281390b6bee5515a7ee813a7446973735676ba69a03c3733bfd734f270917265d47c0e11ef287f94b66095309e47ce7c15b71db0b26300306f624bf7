
/**
 * @cypress/vue v0.0.0-development
 * (c) 2021 Cypress.io
 * Released under the MIT License
 */

import { mount as mount$1 } from '@vue/test-utils';
import { ROOT_ID, injectStylesBeforeElement, setupHooks } from '@cypress/mount-utils';

/*! *****************************************************************************
Copyright (c) Microsoft Corporation.

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
***************************************************************************** */

var __assign = function() {
    __assign = Object.assign || function __assign(t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
            s = arguments[i];
            for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p)) t[p] = s[p];
        }
        return t;
    };
    return __assign.apply(this, arguments);
};

var DEFAULT_COMP_NAME = 'unknown';
var initialInnerHtml = '';
Cypress.on('run:start', function () {
    // `mount` is designed to work with component testing only.
    // it assumes ROOT_ID exists, which is not the case in e2e.
    // if the user registers a custom command that imports `cypress/vue`,
    // this event will be registered and cause an error when the user
    // launches e2e (since it's common to use Cypress for both CT and E2E.
    // https://github.com/cypress-io/cypress/issues/17438
    if (Cypress.testingType !== 'component') {
        return;
    }
    initialInnerHtml = document.head.innerHTML;
    Cypress.on('test:before:run', function () {
        var _a;
        (_a = Cypress.vueWrapper) === null || _a === void 0 ? void 0 : _a.unmount();
        // @ts-ignore
        var document = cy.state('document');
        var el = document.getElementById(ROOT_ID);
        if (!el) {
            throw Error("no element found at query #" + ROOT_ID + ". Please use the mount utils to mount it properly");
        }
        el.innerHTML = '';
        document.head.innerHTML = initialInnerHtml;
    });
});
// implementation
function mount(componentOptions, options) {
    if (options === void 0) { options = {}; }
    // TODO: get the real displayName and props from VTU shallowMount
    var componentName = getComponentDisplayName(componentOptions);
    var message = "<" + componentName + " ... />";
    var logInstance;
    // then wait for cypress to load
    return cy.then(function () {
        var _a, _b;
        if (options.log !== false) {
            logInstance = Cypress.log({
                name: 'mount',
                message: [message],
            });
        }
        // @ts-ignore
        var document = cy.state('document');
        var el = document.getElementById(ROOT_ID);
        if (!el) {
            throw Error("no element found at query #" + ROOT_ID + ". Please use the mount utils to mount it properly");
        }
        injectStylesBeforeElement(options, document, el);
        // merge the extensions with global
        if (options.extensions) {
            options.extensions.plugins = (_a = []) === null || _a === void 0 ? void 0 : _a.concat(options.extensions.plugins || [], options.extensions.use || []);
            options.extensions.mixins = (_b = []) === null || _b === void 0 ? void 0 : _b.concat(options.extensions.mixins || [], options.extensions.mixin || []);
            options.global = __assign(__assign({}, options.extensions), options.global);
        }
        var componentNode = document.createElement('div');
        componentNode.id = '__cy_vue_root';
        el.append(componentNode);
        // mount the component using VTU and return the wrapper in Cypress.VueWrapper
        var wrapper = mount$1(componentOptions, __assign({ attachTo: componentNode }, options));
        Cypress.vueWrapper = wrapper;
        Cypress.vue = wrapper.vm;
        return cy
            .wrap(wrapper, { log: false })
            .wait(1, { log: false })
            .then(function () {
            if (logInstance) {
                logInstance.snapshot('mounted');
                logInstance.end();
            }
            // by returning undefined we keep the previous subject
            // which is the mounted component
            return undefined;
        });
    });
}
/**
 * Extract the compoennt name from the object passed to mount
 * @param componentOptions the compoennt passed to mount
 * @returns name of the component
 */
function getComponentDisplayName(componentOptions) {
    if (componentOptions.name) {
        return componentOptions.name;
    }
    if (componentOptions.__file) {
        var filepathSplit = componentOptions.__file.split('/');
        var fileName = filepathSplit[filepathSplit.length - 1];
        // remove the extension .js, .ts or .vue from the filename to get the name of the component
        var baseFileName = fileName.replace(/\.(js|ts|vue)?$/, '');
        // if the filename is index, then we can use the direct parent foldername, else use the name itself
        return (baseFileName === 'index' ? filepathSplit[filepathSplit.length - 2] : baseFileName);
    }
    return DEFAULT_COMP_NAME;
}
/**
 * Helper function for mounting a component quickly in test hooks.
 * @example
 *  import {mountCallback} from '@cypress/vue'
 *  beforeEach(mountVue(component, options))
 */
function mountCallback(component, options) {
    if (options === void 0) { options = {}; }
    return function () {
        return mount(component, options);
    };
}
setupHooks();

export { mount, mountCallback };
