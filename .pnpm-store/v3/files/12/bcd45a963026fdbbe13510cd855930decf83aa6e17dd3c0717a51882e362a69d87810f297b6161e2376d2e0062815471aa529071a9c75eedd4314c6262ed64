# node-unique-machine-id

**Get the unique machine id (cross-platform, without admin privileges)**

## Installation

```
npm install node-unique-machine-id
```

## Usage

```js
import { machineId, machineIdSync } from 'node-unique-machine-id';

// or async... await...
machineId().then(id => {
  console.log(id);
  //=> e7da09af80e39cd1b2af442ce529f90d5f607ed626a31e869ac48c6a6148b4a3
});

const id = machineIdSync(true);
console.log(id);
//=> 98912984-c4e9-5ceb-8000-03882a0485e4
```

## API

### machineId(original?:boolean, fallthrough?: boolean)

### machineIdSync(original?:boolean, fallthrough?: boolean)

**original**: default: `false`. If `true` return original value of machine id, otherwise return hashed value (sha-256)

**fallthrough**: default: `false`. If `true`, uuid will be generated and saved when there is an error in obtaining (use for Unsupported platforms)

## Thanks

- [automation-stack/node-machine-id](https://github.com/automation-stack/node-machine-id)

- [Get Hardware UUID in Mac OS X](https://www.commandlinefu.com/commands/view/24201/-get-hardware-uuid-in-mac-os-x)

- [The Best Way To Uniquely Identify A Windows Machine - Next of Windows](https://www.nextofwindows.com/-the-best-way-to-uniquely-identify-a-windows-machine)
