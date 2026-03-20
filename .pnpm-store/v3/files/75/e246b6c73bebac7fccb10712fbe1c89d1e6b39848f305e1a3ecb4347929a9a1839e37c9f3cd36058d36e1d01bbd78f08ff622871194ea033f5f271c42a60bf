"use strict";
var __assign = (this && this.__assign) || function () {
    __assign = Object.assign || function(t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
            s = arguments[i];
            for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
                t[p] = s[p];
        }
        return t;
    };
    return __assign.apply(this, arguments);
};
exports.__esModule = true;
exports.pluginVueEnv = void 0;
var dotenv_1 = require("dotenv");
var PLUGIN_NAME = 'vite-plugin-vue-env';
function pluginVueEnv(variables, args) {
    if (variables === void 0) { variables = {}; }
    if (args === void 0) { args = {}; }
    var options = __assign({ fileRegexp: /\.(m?jsx?|tsx?|vue)$/i, getEnvFullName: function (name) { return "process.env.".concat(name); }, variablePrefix: 'VUE_APP_', debug: false }, args);
    var dotenvVars = Object.entries((0, dotenv_1.config)(options.dotenvConfigOptions).parsed || {}).reduce(function (acc, _a) {
        var name = _a[0], value = _a[1];
        if (name.toLowerCase().startsWith(String(options.variablePrefix).toLowerCase())) {
            acc[options.getEnvFullName(name)] = JSON.stringify(value);
        }
        return acc;
    }, {});
    var userVars = Object.entries(variables).reduce(function (acc, _a) {
        var name = _a[0], value = _a[1];
        acc[options.getEnvFullName(name)] = JSON.stringify(value);
        return acc;
    }, {});
    var allVars = __assign(__assign({}, dotenvVars), userVars);
    if (options.debug) {
        console.group(PLUGIN_NAME);
        console.log(allVars);
        console.groupEnd();
    }
    return {
        name: PLUGIN_NAME,
        transform: function (code, id) {
            var isJs = id.match(options.fileRegexp);
            if (isJs) {
                return {
                    code: Object.entries(allVars).reduce(function (acc, _a) {
                        var name = _a[0], value = _a[1];
                        return acc.replace(new RegExp(name, 'g'), value);
                    }, code)
                };
            }
        }
    };
}
exports.pluginVueEnv = pluginVueEnv;
exports["default"] = pluginVueEnv;
