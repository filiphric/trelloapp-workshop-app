"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.overrideSourceMaps = void 0;
var debug = require('debug')('cypress:webpack');
var _ = require('lodash');
var patched = false;
var getProgramOptions = function (rootNamesOrOptions, options) {
    return _.isArray(rootNamesOrOptions) ? options : rootNamesOrOptions.options;
};
var overrideSourceMaps = function (sourceMap, typescriptPath) {
    try {
        if (patched) {
            debug('typescript.createProgram() already overridden');
            return;
        }
        // when using webpack-preprocessor as a local filesystem dependency (`file:...`),
        // require(typescript) will resolve to this repo's `typescript` devDependency, not the
        // targeted project's `typescript`, which breaks monkeypatching. resolving from the
        // CWD avoids this issue.
        var projectTsPath = require.resolve(typescriptPath || 'typescript', {
            paths: [process.cwd()],
        });
        var typescript_1 = require(projectTsPath);
        var createProgram_1 = typescript_1.createProgram;
        debug('typescript found, overriding typescript.createProgram()');
        typescript_1.createProgram = function () {
            var args = [];
            for (var _i = 0; _i < arguments.length; _i++) {
                args[_i] = arguments[_i];
            }
            var rootNamesOrOptions = args[0], _options = args[1];
            var options = getProgramOptions(rootNamesOrOptions, _options);
            debug('typescript unmodified createProgram options %o', options);
            // if sourceMap has been set then apply
            // these overrides to force typescript
            // to generate the right sourcemaps
            options.sourceMap = sourceMap;
            delete options.inlineSources;
            delete options.inlineSourceMap;
            debug('typescript modified createProgram options %o', options);
            // @ts-ignore
            return createProgram_1.apply(typescript_1, args);
        };
        patched = true;
    }
    catch (err) {
        debug('typescript not found');
        // for testing purposes
        return err;
    }
};
exports.overrideSourceMaps = overrideSourceMaps;
