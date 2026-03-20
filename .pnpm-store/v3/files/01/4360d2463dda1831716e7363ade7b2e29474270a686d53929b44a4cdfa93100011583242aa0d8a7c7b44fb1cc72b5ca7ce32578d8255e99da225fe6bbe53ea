/* Copyright 2014 Open Ag Data Alliance
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

'use strict';

var jws = require('jws');
// TODO: Use a better module for this
var pem = require('rsa-pem-from-mod-exp');
var objectAssign = require('object-assign');
var utils = require('./utils');

var shims = {};

var sign = jws.sign;
shims.sign = function(options) {
    var key = options && (options.privateKey || options.secret);

    if (utils.isJWK(key)) {
        var secret;
        switch (key.kty) {
            case 'PEM':
                secret = key.pem;
                break;
            default:
                throw new utils.KeyTypeError(key.kty);
        }

        options = objectAssign({header: {}}, options);
        // Override algorithm with value from JWK
        options.header.alg = key.alg || options.header.alg;
        // Add Key ID to JOSE header
        options.header.kid = key.kid;
        // Put it in both?
        options.privateKey = options.secret = secret;
    }

    return sign(options);
};

var verify = jws.verify;
shims.verify = function(signature, secretOrKey) {
    var jwk = utils.jwkForSignature(signature, secretOrKey);

    if (jwk) {
        switch (jwk.kty) {
            case 'PEM':
                secretOrKey = jwk.pem;
                break;
            case 'RSA':
                secretOrKey = pem(jwk.n, jwk.e);
                break;
            default:
                throw new utils.KeyTypeError(jwk.kty);
        }
    }

    return verify(signature, secretOrKey);
};

module.exports = shims;
