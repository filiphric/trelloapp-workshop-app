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

var utils = {};

// Decide if an object is a JWK
utils.isJWK = function isJWK(key) {
    return !!(key && key.kty);
};
// Decide if an object is a set of JWKs
utils.isJWKset = function isJWKset(set) {
    var keys = set && set.keys;

    return keys && (typeof keys.some === 'function') && keys.some(utils.isJWK);
};

// Pick a JWK from a JWK set by its Key ID
utils.findJWK = function findJWK(kid, jwks) {
    var res;

    jwks.keys.every(function(jwk) {
        if (utils.isJWK(jwk) && (jwk.kid === kid)) {
            res = jwk;
            return false;
        }
        return true;
    });

    if (!res) {
        throw new Error('Provided JWKs did not contain the JWK for this JWS');
    }

    return res;
};

utils.jwkForSignature = function jwkForSignature(signature, secretOrKey) {
    var jwk;

    if (utils.isJWKset(secretOrKey)) {
        var kid = jws.decode(signature).header.kid;

        jwk = utils.findJWK(kid, secretOrKey);
    } else if (utils.isJWK(secretOrKey)) {
        jwk = secretOrKey;
    }

    return jwk;
};

utils.KeyTypeError = function KeyTypeError(kty) {
    this.name = 'JSONWebKeyTypeError';
    this.message = 'Unsupported JWK Key Type' + (kty && (': ' + kty) || '');
};
utils.KeyTypeError.prototype = TypeError.prototype;

module.exports = utils;
