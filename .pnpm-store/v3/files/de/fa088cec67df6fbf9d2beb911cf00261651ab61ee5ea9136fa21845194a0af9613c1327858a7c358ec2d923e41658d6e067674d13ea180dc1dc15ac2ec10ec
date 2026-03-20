import * as htmlparser2 from 'htmlparser2';

declare module 'htmlparser2' {
    interface TokenizerHandler {
        ontext: (text: string) => void;
        onopentagend: () => void;
        onopentagname: (name: string) => void;
        onselfclosingtag: () => void;
        onattribname: (name: string) => void;
        onattribdata: (value: string) => void;
        onattribend: () => void;
        ondeclaration: (declaration: string) => void;
        onprocessinginstruction: (instruction: string) => void;
        oncomment: (data: string) => void;
        oncdata: (data: string) => void;
        onerror: (error: Error) => void;
        onend: () => void;
        onclosetag: (name: string) => void;
    }

    interface TokenizerOptions {
        /***
         * Indicates whether special tags (<script> and <style>) should get special treatment
         * and if "empty" tags (eg. <br>) can have children.  If false, the content of special tags
         * will be text only. For feeds and other XML content (documents that don't consist of HTML),
         * set this to true. Default: false.
         */
        xmlMode?: boolean;

        /***
         * If set to true, entities within the document will be decoded. Defaults to false.
         */
        decodeEntities?: boolean;
    }

    interface Handler {
        onopentagend?: () => void;
    }

    interface Parser {
        startIndex: number;
        endIndex: number;

        _tokenizer: Tokenizer;

        ontext: (text: string) => void;
        onopentagend: () => void;
        onopentagname: (name: string) => void;
        onselfclosingtag: () => void;
        onattribname: (name: string) => void;
        onattribdata: (value: string) => void;
        onattribend: () => void;
        ondeclaration: (declaration: string) => void;
        onprocessinginstruction: (instruction: string) => void;
        oncomment: (data: string) => void;
        oncdata: (data: string) => void;
        onerror: (error: Error) => void;
        onend: () => void;
        onclosetag: (name: string) => void;
    }

    interface Tokenizer {
        constructor(options: TokenizerOptions, handler: TokenizerHandler);

        write(chunk: string): void;
        end(chunk?: string): void;
        pause(): void;
        resume(): void;
        reset(): void;
        getAbsoluteIndex(): number;

        _sectionStart: number;
        _index: number;
        _buffer: string;
        _bufferOffset: number;
        _state: number;
        _running: boolean;
        _ended: boolean;
    }
}