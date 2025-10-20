import { Idiomorph } from 'idiomorph';

class RailsPerformanceAutoupdate extends HTMLElement {
  connectedCallback() {
    this.checkbox = this.querySelector('input[type="checkbox"]');
    this.initializeCheckboxState();
    this.setupCheckboxListener();
    this.startPolling();
  }

  initializeCheckboxState() {
    if (localStorage.getItem('autoupdate') === null) {
      localStorage.setItem('autoupdate', 'true');
    }
    this.checkbox.checked = localStorage.getItem('autoupdate') === 'true';
  }

  setupCheckboxListener() {
    this.checkbox.addEventListener('change', () => {
      localStorage.setItem('autoupdate', this.checkbox.checked);
    });
  }

  startPolling() {
    setInterval(() => this.poll(), 3000);
  }

  async poll() {
    if (!this.checkbox.checked) return;

    const html = await this.fetchPage();
    const newDoc = this.parseHtml(html);
    this.morphPage(newDoc);
  }

  async fetchPage() {
    const res = await fetch(window.location.href, {
      headers: {
        'X-CSRF-Token': document.querySelector("[name='csrf-token']").content,
      },
    });
    return await res.text();
  }

  parseHtml(html) {
    const parser = new DOMParser();
    return parser.parseFromString(html, 'text/html');
  }

  morphPage(newDoc) {
    Idiomorph.morph(document.body, newDoc.body, {
      callbacks: {
        beforeNodeMorphed: (oldNode, newNode) => {
          if (oldNode === this) {
            return false;
          }
          if (oldNode.hasAttribute && oldNode.hasAttribute('data-skip-autoupdate')) {
            return false;
          }
        }
      }
    });
  }
}

customElements.define('rails-performance-autoupdate', RailsPerformanceAutoupdate);
