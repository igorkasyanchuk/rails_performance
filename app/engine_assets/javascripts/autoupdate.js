import { Idiomorph } from 'idiomorph';
import ms from 'ms';

class RailsPerformanceAutoupdate extends HTMLElement {
  connectedCallback() {
    this.checkbox = this.querySelector('input[type="checkbox"]');
    this.intervalMs = this.parseIntervalAttribute();
    this.initializeCheckboxState();
    this.setupCheckboxListener();
    this.startPolling();
  }

  parseIntervalAttribute() {
    return ms(this.getAttribute('interval') || '3s');
  }

  initializeCheckboxState() {
    const key = this.storageKey();
    if (localStorage.getItem(key) === null) {
      localStorage.setItem(key, 'true');
    }
    this.checkbox.checked = localStorage.getItem(key) === 'true';
  }

  setupCheckboxListener() {
    this.checkbox.addEventListener('change', () => {
      localStorage.setItem(this.storageKey(), this.checkbox.checked);
    });
  }

  startPolling() {
    setInterval(() => this.poll(), this.intervalMs);
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
          // skip morphing the autoupdate component itself
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

  storageKey() {
    return `rails-performance-autoupdate:${window.location.pathname}`;
  }
}

customElements.define('rails-performance-autoupdate', RailsPerformanceAutoupdate);
