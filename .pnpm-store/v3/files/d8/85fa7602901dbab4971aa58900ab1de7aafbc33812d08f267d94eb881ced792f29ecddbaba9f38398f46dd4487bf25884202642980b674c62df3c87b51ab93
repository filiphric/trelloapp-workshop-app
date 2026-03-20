import { DotenvConfigOptions } from 'dotenv';
declare type Variables = Record<string, string>;
interface Options {
    fileRegexp: RegExp;
    getEnvFullName(name: string): string;
    variablePrefix: string;
    dotenvConfigOptions?: DotenvConfigOptions;
    debug?: boolean;
}
declare function pluginVueEnv(variables?: Variables, args?: Partial<Options>): {
    name: string;
    transform(code: string, id: string): {
        code: string;
    };
};
export { pluginVueEnv };
export default pluginVueEnv;
