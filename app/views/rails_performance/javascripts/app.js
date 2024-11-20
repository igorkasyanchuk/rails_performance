function showChart(element_id, type, options) {
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
      }  
    }
  );
  chart.render();
}

function showTIRChart(element_id, data, addon, name) {
  showChart(element_id, 'area', {
    tooltip: {
      style: {
        fontSize: '16px'
      },
      x: {
        show: false,
        format: 'dd/MM/yy HH:mm'
      },
      y: {
        formatter: value => (value ? value + addon : undefined)
      },
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
      opposite: true,
      title: {
        text: 'RPM',
        style: {
          color: "#f6f6f6"
        }
      },
      labels: {
        style: {
          colors: ["#a6b0cf"]
        }
      }
    },
    series: [{
      name: name,
      data: data
    }]
  });
}

function showRTChart(element_id, data) {
  showChart(element_id, 'area', {
    tooltip: {
      style: {
        fontSize: '16px',
      },
      x: {
        show: false,
        format: 'dd/MM/yy HH:mm'
      },
      y: {
        formatter: value => (value ? value + ' ms': undefined)
      }
    },
    xaxis: {
      crosshairs: {
        show: false
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
      opposite: true,
      title: {
        text: 'Time',
        style: {
          color: "#f6f6f6"
        }
      },
      labels: {
        style: {
          colors: ["#a6b0cf"]
        }
      }
    },
    series: [{
      name: 'Response Time',
      data: data,
    }],
  });
}

function showPercentageChart(element_id, data, name) {
  showChart(element_id, 'line', {
    tooltip: {
      style: {
        fontSize: '16px',
      },
      x: {
        show: false,
        format: 'dd/MM/yy HH:mm'
      },
      y: {
        formatter: value => (value ? value + ' %' : undefined)
      }
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
      opposite: true,
      title: {
        text: '%',
        style: {
          color: "#f6f6f6"
        }
      },
      labels: {
        style: {
          colors: ["#a6b0cf"]
        }
      }
    },
    series: [{
      name: name,
      data: data,
    }]
  });
}

function showUsageChart(element_id, data, name, pow) {
  showChart(element_id, 'line', {
    markers: {
      size: 0,
      hover: {
        size: 2
      }
    },
    tooltip: {
      style: {
        fontSize: '16px',
      },
      x: {
        show: false,
        format: 'dd/MM/yy HH:mm'
      },
      y: {
        formatter: value => human_bytes(value, pow)
      }
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
      opposite: true,
      title: {
        text: name,
        style: {
          color: "#f6f6f6"
        }
      },
      labels: {
        style: {
          colors: ["#a6b0cf"]
        }
      }
    },
    series: [{
      name: name,
      data: data.map(([t, b]) => [t, (b / Math.pow(1024, pow)).toFixed(2)]),
    }]
  });
}

function human_bytes(value, pow = 0) {
  if (!value) return;
  const units = ['bytes', 'KB', 'MB', 'GB', 'TB', 'PB'];
  return `${value} ${units[pow]}`;
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
