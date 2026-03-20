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

/*jshint browser: true*/
'use strict';

var jsrsasign = require('jsrsasign');
var jsjws = jsrsasign.jws;
var utils = require('./utils');

// Fix it?
jsjws.JWS.prototype.isSafeJSONString = jsjws.JWS.isSafeJSONString;

var shims = {};

shims.sign = function() {
    throw new Error('JWS signing not supported in browser');
};

shims.verify = function(signature, secretOrKey) {
    var jwk = utils.jwkForSignature(signature, secretOrKey);

    if (!jwk) {
        // Make PEMs still work
        jwk.pem = secretOrKey;
        jwk.kty = 'PEM';
    }

    switch (jwk.kty) {
        case 'PEM':
            return (new jsjws.JWS()).verifyJWSByKey(signature, jwk.pem);
        case 'RSA':
            var hN = jsrsasign.b64utohex(jwk.n);
            var hE = jsrsasign.b64utohex(jwk.e);
            return (new jsjws.JWS()).verifyJWSByNE(signature, hN, hE);
        default:
            throw new utils.KeyTypeError();
    }
};

module.exports = shims;
