import { AST } from 'eslint';
import { Statement, ModuleDeclaration } from 'estree';

export type HTMLTokenType = 
    | 'HTMLAttributeName'
    | 'HTMLAttributeValue'
    | 'HTMLAttribute'
    | 'HTMLText'
    | 'HTMLWhitespace'
    | 'HTMLElement'
    | 'HTMLComment'
    | 'HTMLProcessingInstruction'
    | 'Program'

export interface ESLintHTMLParserToken {
    type: HTMLTokenType | AST.TokenType;
    value: string;
    range: AST.Range;
    loc: AST.SourceLocation;
}

export interface HTMLAttributeName extends ESLintHTMLParserToken {
    type: 'HTMLAttributeName';
    parent: HTMLAttribute;
}

export interface HTMLAttributeValue extends ESLintHTMLParserToken {
    type: 'HTMLAttributeValue';
    parent: HTMLAttribute;
}

export interface HTMLAttribute extends ESLintHTMLParserToken {
    type: 'HTMLAttribute';
    parent: HTMLElement;
    attributeName: HTMLAttributeName;
    attributeValue: HTMLAttributeValue;
}

export interface HTMLText extends ESLintHTMLParserToken {
    type: 'HTMLText';
    parent: HTMLElement;
}

export interface HTMLWhitespace extends ESLintHTMLParserToken {
    type: 'HTMLWhitespace';
    parent: HTMLElement;
}

export interface HTMLComment extends ESLintHTMLParserToken {
    type: 'HTMLComment';
    parent: HTMLElement;
    text: string;
}

export interface HTMLProcessingInstruction extends ESLintHTMLParserToken {
    type: 'HTMLProcessingInstruction';
    target: string;
    data: string;
}

export interface HTMLElement extends ESLintHTMLParserToken {
    comments: string[];
    type: 'HTMLElement';
    tagName: string;
    parent?: HTMLElement;
    attributes?: HTMLAttribute[];
    children?: (HTMLElement | HTMLText | HTMLWhitespace | HTMLComment | Statement | ModuleDeclaration)[];
}