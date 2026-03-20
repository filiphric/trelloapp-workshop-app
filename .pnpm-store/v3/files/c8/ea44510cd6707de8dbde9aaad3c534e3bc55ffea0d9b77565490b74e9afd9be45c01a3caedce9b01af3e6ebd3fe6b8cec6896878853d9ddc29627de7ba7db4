import { AST, SourceCode } from "eslint";
import { HTMLElement, ESLintHTMLParserToken } from "./elements";
import { ScopeManager } from "eslint-scope";

export interface HTMLSyntaxTree extends ESLintHTMLParserToken {
    comments: any[];
    tokens: ESLintHTMLParserToken[];
    root: HTMLElement;
    type: 'Program'
}

export interface ESLintHtmlParseResult {
    ast: HTMLSyntaxTree | AST.Program;
    services?: Object;
    scopeManager?: ScopeManager;
    visitorKeys?: SourceCode.VisitorKeys;
}