function showChart(element_id, type, title, options) {
  const chart = new ApexCharts(
    document.getElementById(element_id),
    {
      ...options,
      chart: {
        type: type,
        height: 300,
        zoom: {
          type: 'x',
        },
      },
      colors: ['#ff5b5b'],
      stroke: {
        width: 1,
      },
      dataLabels: {
        enabled: false
      },
      legend: {
        show: false
      },
      xaxis: {
        crosshairs: {
          show: true
        },
        type: 'datetime',
        labels: {
          datetimeUTC: false,
          style: {
            colors: ["#a6b0cf"]
          }
        }
      },
      yaxis: {
        min: 0,
        title: {
          text: title,
          style: {
            color: "#f6f6f6"
          }
        },
        labels: {
          style: {
            colors: ["#a6b0cf"]
          }
        }
      }
    }
  );
  chart.render();
}

function tooltipOptions(formatter) {
  return {
    style: {
      fontSize: '16px'
    },
    marker: {
      show: false,
    },
    x: {
      show: false,
      format: 'dd/MM/yy HH:mm'
    },
    y: {
      formatter: formatter,
      title: {
        formatter: () => '',
      }
    }
  };
}

function showTIRChart(element_id, data, addon, name) {
  showChart(element_id, 'area', 'RPM', {
    tooltip: tooltipOptions(value => (value ? value + addon : undefined)),
    series: [{
      name: name,
      data: data
    }]
  });
}

function showRTChart(element_id, data) {
  showChart(element_id, 'area', 'Time', {
    tooltip: tooltipOptions(value => (value ? value + ' ms' : undefined)),
    series: [{
      name: 'Response Time',
      data: data,
    }],
  });
}

function showPercentageChart(element_id, data, name) {
  showChart(element_id, 'line', '%', {
    tooltip: tooltipOptions(value => (value ? value + ' %' : undefined)),
    series: [{
      name: name,
      data: data,
    }]
  });
}

function showUsageChart(element_id, data, name, pow) {
  const units = ['bytes', 'KB', 'MB', 'GB', 'TB', 'PB'][pow];
  const bytes = Math.pow(1024, pow);

  showChart(element_id, 'line', name, {
    tooltip: tooltipOptions(value => (value ? `${value} ${units}` : undefined)),
    series: [{
      name: name,
      data: data.map(([timestamp, value]) => [timestamp, typeof value === 'number' ? (value / bytes).toFixed(2) : null]),
    }]
  });
}

const recent = document.getElementById("recent");
const autoupdate = document.getElementById("autoupdate");

if (autoupdate) {
  // set autoupdate checked from localStorage is missing
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
