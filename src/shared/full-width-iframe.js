const RESIZE_REFRESH = 150

window.customElements.define('full-width-iframe', class extends HTMLElement {
  connectedCallback() {
    this._resizeListener = () => this.resizeListener()
    window.addEventListener('resize', this._resizeListener)
    this.sizeAndRender()
  }

  disconnectedCallback() {
    window.removeEventListener('resize', this._resizeListener)
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
    this.render()
  }

  calcDimensions() {
    if (!this.ratio) return console.warn('no original sizes defined, cannot size iframe')

    const { width } = this.parentElement.getBoundingClientRect()

    this.width = width
    this.height = width / this.ratio
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
})
