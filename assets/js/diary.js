import FullWidthIframe from './shared/full-width-iframe.js'
import "@webcomponents/webcomponentsjs/webcomponents-loader"

window.addEventListener('WebComponentsReady', function() {
  window.customElements.define('full-width-iframe', FullWidthIframe)
});
