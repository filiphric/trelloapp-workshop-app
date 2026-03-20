"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const path = require("path");
const eslint_scope_1 = require("eslint-scope");
const htmlparser2_1 = require("htmlparser2");
const startsWithHtmlTag = /^\s*</;
function isHtmlFile(code, options) {
    const filePath = options.filePath || "unknown.js";
    return options.htmlFileExtensions.indexOf(path.extname(filePath)) != -1 || startsWithHtmlTag.test(code);
}
function parseScript(code, options) {
    let fallbackParser = require(options.parser);
    if (typeof fallbackParser.parseForESLint == 'function') {
        return fallbackParser.parseForESLint(code, options);
    }
    else {
        return {
            ast: fallbackParser.parse(code, options),
            visitorKeys: fallbackParser.VisitorKeys
        };
    }
}
function parseForESLint(code, options) {
    options = Object.assign({
        htmlFileExtensions: ['.htm', '.html'],
        parser: 'espree',
        comment: true,
        loc: true,
        range: true,
        tokens: true
    }, options || {});
    if (!isHtmlFile(code, options)) {
        return parseScript(code, options);
    }
    let lineBreakIndices = [-1];
    let currentIndex = code.indexOf('\n');
    while (currentIndex != -1) {
        lineBreakIndices.push(currentIndex);
        currentIndex = code.indexOf('\n', currentIndex + 1);
    }
    let tabIndices = [];
    currentIndex = code.indexOf('\t');
    while (currentIndex != -1) {
        tabIndices.push(currentIndex);
        currentIndex = code.indexOf('\t', currentIndex + 1);
    }
    function getLineAndColumn(index) {
        let lineNumber = 0;
        for (; lineNumber < lineBreakIndices.length; lineNumber++) {
            if (index < lineBreakIndices[lineNumber]) {
                break;
            }
        }
        let column = index - lineBreakIndices[lineNumber - 1] - 1;
        let tabNumber = -1;
        while (++tabNumber < tabIndices.length) {
            if (tabIndices[tabNumber] < lineBreakIndices[lineNumber - 1]) {
                continue;
            }
            if (tabIndices[tabNumber] < index) {
                column += 4;
            }
            else {
                break;
            }
        }
        return {
            line: lineNumber,
            column: column
        };
    }
    let visitorKeys = {
        'Program': ['root'],
        'HTMLAttribute': ['attributeName', 'attributeValue'],
        'HTMLAttributeName': [],
        'HTMLAttributeValue': [],
        'HTMLElement': ['children', 'attributes'],
        'HTMLText': [],
        'HTMLWhitespace': [],
        'HTMLComment': [],
        'HTMLProcessingInstruction': []
    };
    let tokens = [];
    let root = null;
    let currentElement = null;
    let currentAttribute = null;
    let onattribdata = (value) => {
        let startIndex = htmlParser._tokenizer._sectionStart;
        currentAttribute.attributeValue = {
            type: 'HTMLAttributeValue',
            value: value,
            parent: currentAttribute,
            range: [startIndex, startIndex + value.length],
            loc: {
                start: getLineAndColumn(startIndex),
                end: getLineAndColumn(startIndex + value.length)
            }
        };
        currentAttribute.range[1] = startIndex + value.length + 1;
        currentAttribute.value = code.substr(currentAttribute.range[0], currentAttribute.range[1] - currentAttribute.range[0]);
        currentAttribute.loc.end = getLineAndColumn(currentAttribute.range[1]);
        tokens.push(currentAttribute.attributeValue);
    };
    let onattribname = (name) => {
        let attribute = {
            type: 'HTMLAttribute',
            range: [htmlParser._tokenizer._sectionStart, -1],
            parent: currentElement,
            attributeName: null,
            attributeValue: null,
            value: null,
            loc: {
                start: getLineAndColumn(htmlParser._tokenizer._sectionStart),
                end: null
            }
        };
        attribute.attributeName = {
            type: 'HTMLAttributeName',
            value: name,
            parent: attribute,
            range: [attribute.range[0], attribute.range[0] + name.length],
            loc: {
                start: getLineAndColumn(attribute.range[0]),
                end: getLineAndColumn(attribute.range[0] + name.length)
            }
        };
        currentAttribute = attribute;
        if (!currentElement.attributes) {
            currentElement.attributes = [];
        }
        currentElement.attributes.push(attribute);
        tokens.push(attribute);
        tokens.push(attribute.attributeName);
    };
    let parseHandler = {
        onopentag: () => {
            currentElement.range = [htmlParser.startIndex, -1];
            currentElement.loc = {
                start: getLineAndColumn(htmlParser.startIndex),
                end: null
            };
        },
        onopentagname: (name) => {
            let element = {
                comments: [],
                type: 'HTMLElement',
                tagName: name,
                parent: currentElement,
                value: null,
                range: [-1, -1],
                loc: null
            };
            if (!root) {
                root = element;
            }
            if (currentElement) {
                if (!currentElement.children) {
                    currentElement.children = [];
                }
                currentElement.children.push(element);
            }
            currentElement = element;
            tokens.push(element);
        },
        onclosetag: () => {
            currentElement.range[1] = htmlParser.endIndex + 1;
            currentElement.loc.end = getLineAndColumn(htmlParser.endIndex + 1);
            currentElement.value = code.substr(currentElement.range[0], currentElement.range[1] - currentElement.range[0]);
            currentElement = currentElement.parent;
        },
        ontext: (text) => {
            if (currentElement && currentElement.tagName.toLowerCase() == 'script') {
                let scriptParseResult = parseScript(text, options);
                if (scriptParseResult.ast) {
                    let scriptProgram = scriptParseResult.ast;
                    if (scriptProgram.tokens) {
                        let textStartLoc = getLineAndColumn(htmlParser.startIndex);
                        for (let token of scriptProgram.tokens) {
                            if (token.range) {
                                token.range[0] += htmlParser.startIndex;
                                token.range[1] += htmlParser.startIndex;
                            }
                            if (token.loc) {
                                if (token.loc.start.line == 1) {
                                    token.loc.start.column += textStartLoc.column;
                                }
                                if (token.loc.end.line == 1) {
                                    token.loc.end.column += textStartLoc.column;
                                }
                                token.loc.start.line += textStartLoc.line - 1;
                                token.loc.end.line += textStartLoc.line - 1;
                            }
                        }
                    }
                    if (scriptProgram.body) {
                        if (!currentElement.children) {
                            currentElement.children = [];
                        }
                        currentElement.children.push.apply(currentElement.children, scriptProgram.body);
                    }
                    if (scriptParseResult.visitorKeys) {
                        for (let visitorKey in scriptParseResult.visitorKeys) {
                            if (!visitorKeys[visitorKey]) {
                                visitorKeys[visitorKey] = scriptParseResult.visitorKeys[visitorKey];
                            }
                            else {
                                for (let childKey of scriptParseResult.visitorKeys[visitorKey]) {
                                    if (visitorKeys[visitorKey].indexOf(childKey) == -1) {
                                        visitorKeys[visitorKey].push(childKey);
                                    }
                                }
                            }
                        }
                    }
                }
                return;
            }
            let leadingWhitespace = (text.match(/^\s+/) || [''])[0];
            let trailingWhitespace = leadingWhitespace.length == text.length ? '' : (text.match(/\s+$/) || [''])[0];
            let actualText = leadingWhitespace.length == text.length ? '' : text.substr(leadingWhitespace.length, text.length - leadingWhitespace.length - trailingWhitespace.length);
            if (leadingWhitespace) {
                let leadingWhitespaceToken = {
                    type: 'HTMLWhitespace',
                    parent: currentElement,
                    value: leadingWhitespace,
                    range: [htmlParser.startIndex, htmlParser.startIndex + leadingWhitespace.length],
                    loc: {
                        start: getLineAndColumn(htmlParser.startIndex),
                        end: getLineAndColumn(htmlParser.startIndex + leadingWhitespace.length)
                    }
                };
                if (currentElement) {
                    if (!currentElement.children) {
                        currentElement.children = [];
                    }
                    currentElement.children.push(leadingWhitespaceToken);
                }
                tokens.push(leadingWhitespaceToken);
            }
            if (actualText) {
                let htmlText = {
                    type: 'HTMLText',
                    parent: currentElement,
                    value: actualText,
                    range: [htmlParser.startIndex + leadingWhitespace.length, htmlParser.startIndex + leadingWhitespace.length + actualText.length],
                    loc: {
                        start: getLineAndColumn(htmlParser.startIndex + leadingWhitespace.length),
                        end: getLineAndColumn(htmlParser.startIndex + leadingWhitespace.length + actualText.length)
                    }
                };
                if (currentElement) {
                    if (!currentElement.children) {
                        currentElement.children = [];
                    }
                    currentElement.children.push(htmlText);
                }
                tokens.push(htmlText);
            }
            if (trailingWhitespace) {
                let trailingWhitespaceToken = {
                    type: 'HTMLWhitespace',
                    parent: currentElement,
                    value: trailingWhitespace,
                    range: [htmlParser.startIndex + leadingWhitespace.length + actualText.length, htmlParser.endIndex],
                    loc: {
                        start: getLineAndColumn(htmlParser.startIndex + leadingWhitespace.length + actualText.length),
                        end: getLineAndColumn(htmlParser.endIndex)
                    }
                };
                if (currentElement) {
                    if (!currentElement.children) {
                        currentElement.children = [];
                    }
                    currentElement.children.push(trailingWhitespaceToken);
                }
                tokens.push(trailingWhitespaceToken);
            }
        },
        oncomment: (text) => {
            let comment = {
                type: 'HTMLComment',
                parent: currentElement,
                text: text,
                value: code.substr(htmlParser.startIndex, htmlParser.endIndex - htmlParser.startIndex + 1),
                range: [htmlParser.startIndex, htmlParser.endIndex + 1],
                loc: {
                    start: getLineAndColumn(htmlParser.startIndex),
                    end: getLineAndColumn(htmlParser.endIndex + 1)
                }
            };
            if (currentElement) {
                if (!currentElement.children) {
                    currentElement.children = [];
                }
                currentElement.children.push(comment);
            }
            tokens.push(comment);
        },
        onprocessinginstruction: (name, entireText) => {
            let data = entireText.substr(name.length).replace(/^\s+/, '');
            let processingInstruction = {
                type: 'HTMLProcessingInstruction',
                target: entireText.substr(1, name.length - 1),
                data: data,
                value: code.substr(htmlParser.startIndex, entireText.length + 2),
                range: [htmlParser.startIndex, htmlParser.startIndex + entireText.length + 2],
                loc: {
                    start: getLineAndColumn(htmlParser.startIndex),
                    end: getLineAndColumn(htmlParser.endIndex + 1)
                }
            };
            tokens.push(processingInstruction);
        }
    };
    let htmlParser = new htmlparser2_1.Parser(parseHandler);
    let originalOnattribname = htmlParser.onattribname;
    htmlParser.onattribname = function (name) {
        originalOnattribname.apply(this, arguments);
        onattribname(name);
    };
    let originalOnattribdata = htmlParser.onattribdata;
    htmlParser.onattribdata = function (value) {
        originalOnattribdata.apply(this, arguments);
        onattribdata(value);
    };
    htmlParser.parseComplete(code);
    let syntaxTree = {
        type: 'Program',
        comments: [],
        tokens: tokens,
        root: root,
        loc: root.loc,
        range: root.range,
        value: code.substr(root.range[0], root.range[1] - root.range[0])
    };
    // Can't augment the type declarations to include constructors, so we're
    // stuck with ignoring these two instantiations
    // @ts-ignore
    let scopeManager = new eslint_scope_1.ScopeManager({});
    // @ts-ignore
    let globalScope = new eslint_scope_1.Scope(scopeManager, 'module', null, syntaxTree, false);
    let result = {
        ast: syntaxTree,
        visitorKeys: visitorKeys,
        scopeManager: scopeManager,
        services: {}
    };
    return result;
}
exports.parseForESLint = parseForESLint;
function parse(code, options) {
    return parseForESLint(code, options).ast;
}
exports.parse = parse;
//# sourceMappingURL=index.js.map