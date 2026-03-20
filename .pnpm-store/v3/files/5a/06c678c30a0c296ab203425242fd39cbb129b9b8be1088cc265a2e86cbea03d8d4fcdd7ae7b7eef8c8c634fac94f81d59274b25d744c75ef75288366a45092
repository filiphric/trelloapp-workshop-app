"use strict";
exports.__esModule = true;
var child_process_1 = require("child_process");
var crypto_1 = require("crypto");
var os = require("os");
var fs = require("fs");
var path = require("path");
var UUID = require("uuid");
var getWin32RegBinPath = function () {
    var isWindowsProcessMixedArchitecture = process.arch === 'ia32' &&
        process.env.hasOwnProperty('PROCESSOR_ARCHITEW6432');
    return isWindowsProcessMixedArchitecture
        ? '%windir%\\sysnative\\cmd.exe /c %windir%\\System32'
        : '%windir%\\System32';
};
var command = function (fallthrough) {
    var _platform = process.platform;
    switch (_platform) {
        case 'darwin':
            return "system_profiler SPHardwareDataType | awk '/UUID/ { print $3; }'";
        case 'linux':
            return "( cat /var/lib/dbus/machine-id /etc/machine-id 2> /dev/null || hostname ) | head -n 1 || :";
        case 'win32':
            return getWin32RegBinPath() + "\\REG.exe QUERY HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Cryptography /v MachineGuid";
        case 'freebsd':
            return 'kenv -q smbios.system.uuid || sysctl -n kern.hostuuid';
        default:
            if (!fallthrough) {
                throw new Error("Unsupported platform: " + _platform);
            }
            else {
                return '';
            }
    }
};
var clear = function (result) {
    if (process.platform === 'win32') {
        result = result.split('REG_SZ')[1];
    }
    return result.replace(/\s+/g, '').toLowerCase();
};
var hash = function (guid) {
    return crypto_1.createHash('sha256')
        .update(guid)
        .digest('hex');
};
var genMachineUuid = function () {
    var homeDir = os.homedir();
    var file = path.resolve(homeDir, '.numid');
    var id;
    if (fs.existsSync(file)) {
        var _id = fs
            .readFileSync(file)
            .toString()
            .trim();
        var uuidRegex = /\w{8}-\w{4}-\w{4}-\w{4}-\w{12}/;
        if (uuidRegex.test(_id)) {
            id = _id;
        }
    }
    if (!id) {
        id = UUID.v1();
        fs.writeFileSync(file, id);
    }
    return id;
};
exports.machine = function (original, fallthrough) {
    if (original === void 0) { original = false; }
    if (fallthrough === void 0) { fallthrough = false; }
    return new Promise(function (resolve, reject) {
        return child_process_1.exec(command(fallthrough), function (error, stdout, stderr) {
            var id;
            if (error) {
                if (!fallthrough) {
                    return reject(new Error("Error while obtaining machine id: " + error.stack));
                }
                id = genMachineUuid();
            }
            else {
                id = clear(stdout.toString());
            }
            return resolve(original ? id : hash(id));
        });
    });
};
exports.machineSync = function (original, fallthrough) {
    if (original === void 0) { original = false; }
    if (fallthrough === void 0) { fallthrough = false; }
    var id;
    try {
        id = clear(child_process_1.execSync(command(fallthrough)).toString());
    }
    catch (error) {
        if (!fallthrough) {
            throw new Error("Error while obtaining machine id: " + error.stack);
        }
        id = genMachineUuid();
    }
    return original ? id : hash(id);
};
