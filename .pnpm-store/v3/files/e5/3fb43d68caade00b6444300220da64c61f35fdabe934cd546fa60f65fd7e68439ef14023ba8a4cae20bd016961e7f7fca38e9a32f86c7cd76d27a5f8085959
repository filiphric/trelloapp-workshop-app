interface KeyBind {
    keyCode: string;
    modifiers?: ['altKey' | 'metaKey' | 'ctrlKey' | 'shiftKey'];
    preventDefault: boolean;
    success: {
        (SuccessResult: any): void;
    };
}
interface KeypressOptions {
    keyEvent: 'keydown' | 'keypress' | 'keyup';
    keyBinds: KeyBind[];
    isActive?: any;
    onAnyKey?: {
        (SuccessResult: any): void;
    };
    onWrongKey?: {
        (SuccessResult: any): void;
    };
}
interface KeypressResult {
    event: KeypressResult;
    keyEvent: string;
}
interface SuccessResult extends KeypressResult {
    keyCode: string;
    keyEvent: string;
    modifiers: ['altKey' | 'metaKey' | 'ctrlKey' | 'shiftKey'];
    preventDefault: boolean;
}
