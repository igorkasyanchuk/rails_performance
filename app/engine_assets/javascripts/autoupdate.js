const recent = document.getElementById("recent");
const autoupdate = document.getElementById("autoupdate");

if (autoupdate) {
  if (localStorage.getItem("autoupdate") === null) {
    localStorage.setItem("autoupdate", "true");
  }
  autoupdate.checked = localStorage.getItem("autoupdate") === "true";
  autoupdate.addEventListener('change', () => {
    localStorage.setItem("autoupdate", autoupdate.checked);
  });
}

if (recent) {
  const tbody = recent.querySelector("tbody");

  setInterval(() => {
    const tr = tbody.children[0];
    const from_timei = tr.getAttribute("from_timei") || '';

    if (!autoupdate.checked) {
      return;
    }

    fetch(`recent.js?from_timei=${from_timei}`, {
      headers: {
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
      },
    })
      .then(res => res.text())
      .then(html => {
        tbody.innerHTML = html + tbody.innerHTML;
      });
  }, 3000);
}
