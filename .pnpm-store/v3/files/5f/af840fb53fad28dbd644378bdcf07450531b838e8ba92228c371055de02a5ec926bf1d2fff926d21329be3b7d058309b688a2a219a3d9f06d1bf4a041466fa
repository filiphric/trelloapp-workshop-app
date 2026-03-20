import { DotenvConfigOptions, config as dotenvConfig } from 'dotenv';

const PLUGIN_NAME = 'vite-plugin-vue-env';

type Variables = Record<string, string>;

interface Options {
  fileRegexp: RegExp;
  getEnvFullName(name: string): string;
  variablePrefix: string;
  dotenvConfigOptions?: DotenvConfigOptions;
  debug?: boolean;
}

function pluginVueEnv(variables: Variables = {}, args: Partial<Options> = {}) {
  const options: Options = {
    fileRegexp: /\.(m?jsx?|tsx?|vue)$/i,
    getEnvFullName: (name: string) => `process.env.${name}`,
    variablePrefix: 'VUE_APP_',
    debug: false,
    ...args,
  };

  const dotenvVars = Object.entries(dotenvConfig(options.dotenvConfigOptions).parsed || {}).reduce((acc, [name, value]) => {
    if (name.toLowerCase().startsWith(String(options.variablePrefix).toLowerCase())) {
      acc[options.getEnvFullName(name)] = JSON.stringify(value);
    }
    return acc;
  }, {} as Variables);

  const userVars = Object.entries(variables).reduce((acc, [name, value]) => {
    acc[options.getEnvFullName(name)] = JSON.stringify(value);
    return acc;
  }, {} as Variables);

  const allVars = {
    ...dotenvVars,
    ...userVars,
  };

  if (options.debug) {
    console.group(PLUGIN_NAME);
    console.log(allVars);
    console.groupEnd();
  }

  return {
    name: PLUGIN_NAME,
    transform(code: string, id: string) {
      const isJs = id.match(options.fileRegexp);

      if (isJs) {
        return {
          code: Object.entries(allVars).reduce((acc, [name, value]) => acc.replace(new RegExp(name, 'g'), value), code),
        };
      }
    },
  };
}

export { pluginVueEnv };
export default pluginVueEnv;
