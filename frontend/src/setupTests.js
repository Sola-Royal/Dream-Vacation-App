import '@testing-library/jest-dom';

if (typeof window.MutationObserver === 'undefined') {
  class MutationObserver {
    constructor(callback) {
      this.callback = callback;
      this.nodes = [];
      this.interval = null;
    }

    observe(target) {
      this.target = target;
      this.lastHtml = target.innerHTML;
      this.interval = setInterval(() => {
        if (target.innerHTML !== this.lastHtml) {
          this.lastHtml = target.innerHTML;
          this.callback([], this);
        }
      }, 50);
    }

    disconnect() {
      if (this.interval) {
        clearInterval(this.interval);
        this.interval = null;
      }
    }

    takeRecords() {
      return [];
    }
  }

  window.MutationObserver = MutationObserver;
  global.MutationObserver = MutationObserver;
}
