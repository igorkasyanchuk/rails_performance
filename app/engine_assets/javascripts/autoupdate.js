class RailsPerformanceAutoupdate extends HTMLElement {
  connectedCallback() {
    this.checkbox = this.querySelector('input[type="checkbox"]');
    this.recentTable = document.getElementById('recent');
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
    const tbody = this.recentTable.querySelector('tbody');

    setInterval(() => {
      if(!this.checkbox.checked) return;

      const tr = tbody.children[0];
      const from_timei = tr.getAttribute('from_timei') || '';

      fetch(`recent.js?from_timei=${from_timei}`, {
        headers: {
          'X-CSRF-Token': document.querySelector("[name='csrf-token']").content,
        },
      })
        .then(res => res.text())
        .then(html => {
          tbody.innerHTML = html + tbody.innerHTML;
        });
    }, 3000);
  }
}

customElements.define('rails-performance-autoupdate', RailsPerformanceAutoupdate);
