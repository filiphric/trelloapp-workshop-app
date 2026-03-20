import { SFCBlock, SFCParseOptions, SFCDescriptor } from '@vuedx/compiler-sfc';
import { ComponentRegistrationInfo } from '@vuedx/analyze';
import { CodegenResult, ComponentImport } from '@vuedx/compiler-tsx';
import { RawSourceMap } from 'source-map';
import { TextDocument, Range, Position, TextDocumentContentChangeEvent } from 'vscode-languageserver-textdocument';

declare const TEMPLATE_BLOCK_SELECTOR = "template";
declare const SCRIPT_BLOCK_SELECTOR = "script";
declare const SCRIPT_SETUP_BLOCK_SELECTOR = "scriptSetup";
declare const RENDER_SELECTOR = "_render";
declare const MODULE_SELECTOR = "_module";
declare const INTERNAL_MODULE_SELECTOR = "_internal";
declare const TEMPLATE_AST_SELECTOR = "_ast";
declare type BlockSelector = {
    type: typeof SCRIPT_BLOCK_SELECTOR;
} | {
    type: typeof SCRIPT_SETUP_BLOCK_SELECTOR;
} | {
    type: typeof TEMPLATE_BLOCK_SELECTOR;
} | {
    type: 'style';
    index: number;
} | {
    type: 'customBlocks';
    index: number;
};
declare type Selector = BlockSelector | {
    type: typeof RENDER_SELECTOR;
} | {
    type: typeof MODULE_SELECTOR;
} | {
    type: typeof INTERNAL_MODULE_SELECTOR;
} | {
    type: typeof TEMPLATE_AST_SELECTOR;
};
declare type SelectorLike = Selector | typeof TEMPLATE_BLOCK_SELECTOR | typeof SCRIPT_BLOCK_SELECTOR | typeof SCRIPT_SETUP_BLOCK_SELECTOR | typeof RENDER_SELECTOR | typeof MODULE_SELECTOR | typeof TEMPLATE_AST_SELECTOR | typeof INTERNAL_MODULE_SELECTOR;

declare function getLanguageIdFromExtension(ext: string): string;
declare const VIRTUAL_FILENAME_SEPARATOR = "________";
declare function basename(fileName: string): string;
declare function relativeVirtualImportPath(fileName: string): string;
declare function isVueFile(fileName: string): boolean;
declare function isVirtualFile(fileName: string): boolean;
declare function isVirtualFileOfType(fileName: string, type: '_render' | '_module' | '_internal' | 'script' | 'scriptSetup'): boolean;
declare function getContainingFile(fileName: string): string;
declare function asUri(fileNameOrUri: string): string;
declare function asFsUri(fileName: string): string;
declare function replaceSlashes(fileName: string): string;
declare function asFsPath(uri: string): string;
declare function parseVirtualFileName(fileName: string): {
    uri: string;
    selector: Selector;
} | null;
declare function getBlockLanguage(block?: SFCBlock | null): string;
declare function isOffsetInBlock(offset: number, block?: SFCBlock | null): boolean;
declare function getLanguageExtension(lang: string): string;
declare function binarySearch<T>(array: T[], isMatch: (a: T) => number, returnMin?: boolean): T | undefined;

declare class DocumentStore<T> {
    protected resolve: (uri: string) => T | null;
    normalize: (uri: string) => string;
    protected map: Map<string, T>;
    protected reverseUriMap: Map<string, string>;
    constructor(resolve: (uri: string) => T | null, normalize?: (uri: string) => string);
    protected getNormalizedUri(uri: string): string;
    has(uri: string): boolean;
    get(uri: string): T | null;
    set(uri: string, document: T): void;
    delete(uri: string): boolean;
    all(): string[];
    dispose(): void;
    private loadSync;
}
declare class AsyncDocumentStore<T> extends DocumentStore<T> {
    constructor(resolve: (uri: string) => T | Promise<T | null> | null, normalize?: (uri: string) => string);
    get(uri: string): T | null;
    get(uri: string): Promise<T | null>;
    private load;
}

declare abstract class ProxyTextDocument implements TextDocument {
    protected doc: TextDocument;
    readonly fsPath: string;
    constructor(doc: TextDocument);
    get version(): number;
    get languageId(): string;
    get lineCount(): number;
    get uri(): string;
    getText(): string;
    getText(range: Range): string;
    getText(offset: number, length: number): string;
    positionAt(offset: number): Position;
    offsetAt(position: Position): number;
    protected refresh(): void;
}

interface CreateVirtualTextDocumentOptions<T extends Selector = Selector> {
    container: VueTextDocument;
    selector: T;
    uri: string;
    languageId: string;
    version: number;
    content: string;
}
interface BlockTransformResult {
    code: string;
    map?: RawSourceMap;
}
interface CreateTransformedBlockTextDocumentOptions<T extends Selector = Selector> extends CreateVirtualTextDocumentOptions<T> {
    sourceSelector?: Selector;
    transformer(document: TransformedBlockTextDocument): BlockTransformResult;
}
declare class VirtualTextDocument extends ProxyTextDocument {
    readonly container: VueTextDocument;
    readonly selector: Selector;
    protected isDirty: boolean;
    markDirty(): void;
    protected constructor(container: VueTextDocument, selector: Selector, doc: TextDocument);
    protected refresh(): void;
    static create(options: CreateVirtualTextDocumentOptions): VirtualTextDocument;
}
declare class TransformedBlockTextDocument extends VirtualTextDocument {
    private source;
    private readonly _transform;
    private consumer;
    protected constructor(container: VueTextDocument, selector: Selector, transformed: TextDocument, source: TextDocument | VirtualTextDocument, _transform: (document: TransformedBlockTextDocument) => BlockTransformResult);
    private toTextDocumentPosition;
    private toSourceMapPosition;
    tryGetSourceOffset(offset: number): number | undefined;
    tryGetGeneratedOffset(offset: number): number | undefined;
    protected refresh(): void;
    transform(): BlockTransformResult;
    static create(options: CreateTransformedBlockTextDocumentOptions): TransformedBlockTextDocument;
}
declare class RenderFunctionTextDocument extends TransformedBlockTextDocument {
    private result;
    private originalRange;
    private originalMappings;
    private generatedRange;
    private templateIdentifiersRange;
    private generatedMappings;
    private expressionsMap;
    private _contextCompletionsTriggerOffset;
    private _tagCompletionsTriggerOffset;
    constructor(container: VueTextDocument, selector: Selector, transformed: TextDocument, source: TextDocument);
    get contextCompletionsTriggerOffset(): number;
    get tagCompletionsTriggerOffset(): number;
    get ast(): CodegenResult['ast'] | undefined;
    get parserErrors(): CodegenResult['errors'];
    getOriginalOffsetAt(offset: number): undefined | {
        offset: number;
        length: number;
    };
    findExpression(offset: number, length: number): undefined | {
        offset: number;
        length: number;
    };
    isInGeneratedRange(offset: number): boolean;
    isInTemplateIdentifierRange(offset: number): boolean;
    getGeneratedOffsetAt(offset: number): undefined | {
        length: number;
        offset: number;
    };
    getAllGeneratedOffsetsAt(offset: number): undefined | Array<{
        length: number;
        offset: number;
    }>;
    protected tryGenerate(): string;
    protected generate(): string;
    toDisplayMappings(): string;
    protected getKnownComponents(): Record<string, ComponentImport>;
    static create(options: CreateVirtualTextDocumentOptions): RenderFunctionTextDocument;
}
interface VueTextDocumentOptions {
    vueVersion: string;
    getGlobalComponents(): ComponentRegistrationInfo[];
}
declare class VueTextDocument extends ProxyTextDocument {
    private isDirty;
    private sfc;
    private readonly parseOptions;
    private readonly documents;
    readonly options: VueTextDocumentOptions;
    constructor(doc: TextDocument, options?: VueTextDocumentOptions, parseOptions?: SFCParseOptions);
    get descriptor(): SFCDescriptor;
    all(): VirtualTextDocument[];
    getBlock(selector: BlockSelector): SFCBlock | null | undefined;
    blockAt(position: Position | number): SFCBlock | null | undefined;
    documentAt(position: Position | number): VirtualTextDocument | undefined;
    getBlockSelector(block: SFCBlock): BlockSelector | undefined;
    getDocumentFileName(selectorLike: SelectorLike): string;
    getDocument(selector: typeof RENDER_SELECTOR): RenderFunctionTextDocument;
    getDocument(selector: SelectorLike): VirtualTextDocument;
    getDocument(selector: string): VirtualTextDocument | undefined;
    protected createBlockDocument(selector: BlockSelector): VirtualTextDocument | undefined;
    protected createInternalModuleDocument(): TransformedBlockTextDocument;
    protected createModuleDocument(): TransformedBlockTextDocument;
    protected createTemplateASTDocument(): TransformedBlockTextDocument;
    protected createRenderDocument(): RenderFunctionTextDocument;
    protected getDocumentLanguage(selector: Selector): string;
    protected getDocumentId(selector: Selector): string;
    markDirty(): void;
    protected parse(): void;
    static create(uri: string, languageId: string, version: number, content: string, options?: VueTextDocumentOptions, parseOptions?: SFCParseOptions): VueTextDocument;
    static update(document: VueTextDocument, changes: TextDocumentContentChangeEvent[], version: number): VueTextDocument;
}

export { AsyncDocumentStore, BlockSelector, DocumentStore, INTERNAL_MODULE_SELECTOR, MODULE_SELECTOR, RENDER_SELECTOR, RenderFunctionTextDocument, SCRIPT_BLOCK_SELECTOR, SCRIPT_SETUP_BLOCK_SELECTOR, Selector, SelectorLike, TEMPLATE_AST_SELECTOR, TEMPLATE_BLOCK_SELECTOR, TransformedBlockTextDocument, VIRTUAL_FILENAME_SEPARATOR, VirtualTextDocument, VueTextDocument, asFsPath, asFsUri, asUri, basename, binarySearch, getBlockLanguage, getContainingFile, getLanguageExtension, getLanguageIdFromExtension, isOffsetInBlock, isVirtualFile, isVirtualFileOfType, isVueFile, parseVirtualFileName, relativeVirtualImportPath, replaceSlashes };
