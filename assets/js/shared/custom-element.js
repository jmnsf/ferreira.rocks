class CustomElement extends HTMLElement {
  constructor() {
    super()
    this._listenerRemovers = []
  }

  disconnectedCallback() {
    super.disconnectedCallback()
    this._listenerRemovers.forEach(remover => remover())
  }

  addControlledEventListener(element, event, listener) {
    element.addEventListener(event, listener)
    this._listenerRemovers.push(
      () => element.removeEventListener(event, listener)
    )
  }
}

export default CustomElement
