"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
const vite_1 = require("vite");
const istanbul_lib_instrument_1 = require("istanbul-lib-instrument");
const test_exclude_1 = __importDefault(require("test-exclude"));
const load_nyc_config_1 = require("@istanbuljs/load-nyc-config");
const picocolors_1 = require("picocolors");
// Custom extensions to include .vue files
const DEFAULT_EXTENSION = ['.js', '.cjs', '.mjs', '.ts', '.tsx', '.jsx', '.vue'];
const COVERAGE_PUBLIC_PATH = '/__coverage__';
const PLUGIN_NAME = 'vite:istanbul';
const MODULE_PREFIX = '/@modules/';
const NULL_STRING = '\0';
function sanitizeSourceMap(rawSourceMap) {
    // Delete sourcesContent since it is optional and if it contains process.env.NODE_ENV vite will break when trying to replace it
    const { sourcesContent, ...sourceMap } = rawSourceMap;
    // JSON parse/stringify trick required for istanbul to accept the SourceMap
    return JSON.parse(JSON.stringify(sourceMap));
}
function getEnvVariable(key, prefix, env) {
    if (Array.isArray(prefix)) {
        const envPrefix = prefix.find(pre => {
            const prefixedName = `${pre}${key}`;
            return env[prefixedName] != null;
        });
        prefix = envPrefix !== null && envPrefix !== void 0 ? envPrefix : '';
    }
    return env[`${prefix}${key}`];
}
function createTestExclude(opts) {
    var _a, _b;
    const { nycrcPath, include, exclude, extension } = opts;
    const cwd = (_a = opts.cwd) !== null && _a !== void 0 ? _a : process.cwd();
    const nycConfig = (0, load_nyc_config_1.loadNycConfig)({
        cwd,
        nycrcPath,
    });
    // Only instrument when we want to, as we only want instrumentation in test
    // By default the plugin is always on
    return new test_exclude_1.default({
        cwd,
        include: include !== null && include !== void 0 ? include : nycConfig.include,
        exclude: exclude !== null && exclude !== void 0 ? exclude : nycConfig.exclude,
        extension: (_b = extension !== null && extension !== void 0 ? extension : nycConfig.extension) !== null && _b !== void 0 ? _b : DEFAULT_EXTENSION,
        excludeNodeModules: true,
    });
}
module.exports = function istanbulPlugin(opts = {}) {
    var _a, _b, _c;
    const requireEnv = (_a = opts === null || opts === void 0 ? void 0 : opts.requireEnv) !== null && _a !== void 0 ? _a : false;
    const checkProd = (_b = opts === null || opts === void 0 ? void 0 : opts.checkProd) !== null && _b !== void 0 ? _b : true;
    const forceBuildInstrument = (_c = opts === null || opts === void 0 ? void 0 : opts.forceBuildInstrument) !== null && _c !== void 0 ? _c : false;
    const logger = (0, vite_1.createLogger)('warn', { prefix: 'vite-plugin-istanbul' });
    const testExclude = createTestExclude(opts);
    const instrumenter = (0, istanbul_lib_instrument_1.createInstrumenter)({
        coverageGlobalScopeFunc: false,
        coverageGlobalScope: 'window',
        preserveComments: true,
        produceSourceMap: true,
        autoWrap: true,
        esModules: true,
    });
    // Lazy check the active status of the plugin
    // as this gets fed after config is fully resolved
    let enabled = true;
    return {
        name: PLUGIN_NAME,
        apply: forceBuildInstrument ? 'build' : 'serve',
        // istanbul only knows how to instrument JavaScript,
        // this allows us to wait until the whole code is JavaScript to
        // instrument and sourcemap
        enforce: 'post',
        config(config) {
            var _a;
            // If sourcemap is not set (either undefined or false)
            if (!((_a = config.build) === null || _a === void 0 ? void 0 : _a.sourcemap)) {
                logger.warn(`${PLUGIN_NAME}> ${(0, picocolors_1.yellow)(`Sourcemaps was automatically enabled for code coverage to be accurate.
 To hide this message set build.sourcemap to true, 'inline' or 'hidden'.`)}`);
                // Enforce sourcemapping,
                config.build = config.build || {};
                config.build.sourcemap = true;
            }
        },
        configResolved(config) {
            var _a, _b;
            // We need to check if the plugin should enable after all configuration is resolved
            // As config can be modified by other plugins and from .env variables
            const { isProduction, env } = config;
            const { CYPRESS_COVERAGE } = process.env;
            const envPrefix = (_a = config.envPrefix) !== null && _a !== void 0 ? _a : 'VITE_';
            const envCoverage = opts.cypress
                ? CYPRESS_COVERAGE
                : getEnvVariable('COVERAGE', envPrefix, env);
            const envVar = (_b = envCoverage === null || envCoverage === void 0 ? void 0 : envCoverage.toLowerCase()) !== null && _b !== void 0 ? _b : '';
            if ((checkProd && isProduction && !forceBuildInstrument) ||
                (!requireEnv && envVar === 'false') ||
                (requireEnv && envVar !== 'true')) {
                enabled = false;
            }
        },
        configureServer({ middlewares }) {
            if (!enabled) {
                return;
            }
            // Returns the current code coverage in the global scope
            // Used if an external endpoint is required to fetch code coverage
            middlewares.use((req, res, next) => {
                var _a;
                if (req.url !== COVERAGE_PUBLIC_PATH) {
                    return next();
                }
                const coverage = (_a = (global.__coverage__)) !== null && _a !== void 0 ? _a : null;
                let data;
                try {
                    data = JSON.stringify(coverage, null, 4);
                }
                catch (ex) {
                    return next(ex);
                }
                res.setHeader('Content-Type', 'application/json');
                res.statusCode = 200;
                res.end(data);
            });
        },
        transform(srcCode, id) {
            if (!enabled || id.startsWith(MODULE_PREFIX) || id.startsWith(NULL_STRING)) {
                // do not transform if this is a dep
                // do not transform if plugin is not enabled
                return;
            }
            if (testExclude.shouldInstrument(id)) {
                const sourceMap = sanitizeSourceMap(this.getCombinedSourcemap());
                const code = instrumenter.instrumentSync(srcCode, id, sourceMap);
                const map = instrumenter.lastSourceMap();
                // Required to cast to correct mapping value
                return { code, map };
            }
        },
    };
};
//# sourceMappingURL=index.js.map