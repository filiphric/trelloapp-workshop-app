interface KeyBind {
  keyCode: string
  modifiers?: ['altKey' | 'metaKey' | 'ctrlKey' | 'shiftKey']
  preventDefault: boolean
  success: { (SuccessResult): void }
}

interface KeypressOptions {
  keyEvent: 'keydown' | 'keypress' | 'keyup'
  keyBinds: KeyBind[]
  isActive?: any // TODO
  onAnyKey?: { (SuccessResult): void }
  onWrongKey?: { (SuccessResult): void }
}

interface KeypressResult {
  event: KeypressResult
  keyEvent: string
}

interface SuccessResult extends KeypressResult {
  keyCode: string
  keyEvent: string
  modifiers: ['altKey' | 'metaKey' | 'ctrlKey' | 'shiftKey']
  preventDefault: boolean
}
