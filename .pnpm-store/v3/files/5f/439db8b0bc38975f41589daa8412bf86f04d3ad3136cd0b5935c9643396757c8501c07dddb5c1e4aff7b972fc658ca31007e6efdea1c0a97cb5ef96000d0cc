# [Vite-plugin-vue-env](https://www.npmjs.com/package/vite-plugin-vue-env)

Provide VUE_APP_* env variables to Vite app.

## Installation

```bash
npm i -D vite-plugin-vue-env
```

vite.config.ts
```js
import { defineConfig } from 'vite';
import pluginEnv from 'vite-plugin-vue-env';

export default defineConfig({
  plugins: [
    pluginEnv(),
  ],
});
```

Add `.env` file with any `VUE_APP_*`

## Configuration

```
pluginEnv(variables?, options?)
```

### Variables
Additional variables that will be 'added' to the code, next to .env
- **type**: `object`
- **default**: `{}`

```
pluginEnv({
  APP_ENV: 'development'
})

// [in code] > console.log(process.env.APP_ENV)
```


### Options

- **fileRegexp**: Use this plugin only on files that match this regexp
  - **type**: `RegExp`
  - **default**: `/\.(m?jsx?|tsx?|vue)$/i`

  ```javascript
  pluginEnv({}, {
    fileRegexp: /\.js$/i, // the plugin will be available only in .js files
  })
  ```

- **getEnvFullName**: Customize replaceable string
  - **type**: `function`
  - **default**: `(name: string) => 'process.env.${name}'`

  ```javascript
  pluginEnv({}, {
    getEnvFullName: (name: string) => `ENV.${name}`,
  })

  // [in code] > console.log(ENV.VUE_APP_ENDPOINT)
  ```

- **variablePrefix**: Customize [variable prefix](https://cli.vuejs.org/guide/mode-and-env.html#environment-variables)
  - **type**: `string`
  - **default**: `VUE_APP_`

  ```javascript
  pluginEnv({}, {
    variablePrefix: 'VUE_',
  })

  // [in code] > console.log(process.env.VUE_ENDPOINT)
  ```

- **debug**: Print all variables to the console
  - **type**: `boolean`
  - **default**: `false`


## How it works

Simple, [_maybe stupid_](https://github.com/notiv-nt/vite-plugin-vue-env/pulls)

```
code.replace('process.env.var', 'value')
```
