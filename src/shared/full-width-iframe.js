import CustomElement from './custom-element.js'

const RESIZE_REFRESH = 150

export default class FullWidthIframe extends CustomElement {
  connectedCallback() {
    this.addControlledEventListener(window, 'resize', () => this.resizeListener())
    this.sizeAndRender()
  }

  resizeListener() {
    if (this._resizeTimeout) clearTimeout(this._resizeTimeout)

    this._resizeTimeout = setTimeout(
      () => this.sizeAndRender(),
      RESIZE_REFRESH
    )
  }

  sizeAndRender() {
    this.calcDimensions()

    const iFrame = this.querySelector('iframe')
    if (iFrame && iFrame.getAttribute('width') === String(this.width)) return;

    this.render()
  }

  calcDimensions() {
    if (!this.ratio) return console.warn('no original sizes defined, cannot size iframe')

    const { width } = this.parentElement.getBoundingClientRect()

    this.width = width
    this.height = Math.round(width / this.ratio)
  }

  render() {
    this.innerHTML = '' // clear old state

    const template = document.getElementById('full-width-iframe')
    const iframe = template.content.cloneNode(true).querySelector('iframe')
    iframe.setAttribute('width', this.width)
    iframe.setAttribute('height', this.height)
    iframe.setAttribute('src', this.src)
    this.appendChild(iframe)
  }

  get ratio () {
    if (this._ratio) return this._ratio
    return this._ratio = this.originalWidth / this.originalHeight
  }

  get originalWidth() {
    return this.getAttribute('original-width')
  }

  get originalHeight() {
    return this.getAttribute('original-height')
  }

  get src() {
    return this.getAttribute('src')
  }
}
