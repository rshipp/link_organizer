import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['input'];
  static values = {
    url: String
  };

  connect() {
    if (this.inputTarget.value === "" && this.urlValue !== "") {
      fetch(`https://archive.is/submit/?url=${this.urlValue}`, {redirect: 'follow'}).then(r => {
        if (r.url.match(/archive.is\/\w+$/)) {
          this.inputTarget.value = r.url;
        }
      });
    }
  }
}
