import ApexCharts from "rails_performance/apex_ext"
import ms from "ms"

class RailsPerformanceChart extends HTMLElement {
  connectedCallback() {
    this.legend = this.getAttribute('legend');
    this.units = this.getAttribute('units');
    this.type = this.getAttribute('type');
    this.dataText = this.textContent.trim();
    this.chart = this.buildChart();
    this.observeDataChanges();
  }

  buildChart() {
    if (!this.shadowRoot) {
      this.attachShadow({ mode: 'open' });
    }

    const chartDiv = document.createElement('div');
    this.shadowRoot.innerHTML = '';
    this.shadowRoot.appendChild(chartDiv);

    const data = this.safeParseJson(this.dataText);
    const renderMethod = this[`render${this.type}Chart`];
    return renderMethod.call(this, chartDiv, data);
  }

  safeParseJson(text, defaultValue = []) {
    try { return JSON.parse(text); } catch(e) { return defaultValue; }
  }

  observeDataChanges() {
    this.mutationObserver = new MutationObserver(() => {
      const currentText = this.textContent.trim();
      if (currentText === this.dataText) return;
      this.dataText = currentText;
      const data = this.safeParseJson(currentText);
      this.updateChart(data);
    });
    this.mutationObserver.observe(this, { childList: true, characterData: true, subtree: true });
  }

  updateChart(newData) {
    let incoming = newData;
    if (this.type === 'Usage') {
      const { bytes } = calculateByteUnit(newData);
      incoming = newData.map(([t, v]) => [t, typeof v === 'number' ? (v / bytes).toFixed(2) : null]);
    }
    this.chart.updateRollingWindow(incoming, { windowSizeMs: this.windowSizeMs });
  }

  get windowSizeMs() {
    if (this.type === 'TIR' || this.type === 'RT') {
      return window.railsPerformanceDuration || ms("4h");
    } else {
      return ms("24h");
    }
  }

  renderTIRChart(element, data) {
    return renderChart(element, data, {
      chartType: 'area',
      yAxisTitle: 'RPM',
      seriesName: this.legend,
      units: this.units
    });
  }

  renderRTChart(element, data) {
    return renderChart(element, data, {
      chartType: 'area',
      yAxisTitle: 'Time',
      seriesName: 'Response Time',
      units: 'ms'
    });
  }

  renderPercentageChart(element, data) {
    return renderChart(element, data, {
      chartType: 'line',
      yAxisTitle: '%',
      seriesName: this.legend,
      units: '%'
    });
  }

  renderUsageChart(element, data) {
    const { units, bytes } = calculateByteUnit(data);
    return renderChart(element, data, {
      chartType: 'line',
      yAxisTitle: this.legend,
      seriesName: this.legend,
      units: units,
      dataTransform: (data) => {
        return data.map(([timestamp, value]) => [timestamp, typeof value === 'number' ? (value / bytes).toFixed(2) : null]);
      },
    });
  }
}

customElements.define('rails-performance-chart', RailsPerformanceChart);

function calculateByteUnit(data) {
  let max = data.reduce((acc, [_, value]) => (value > acc ? value : acc), -Infinity);
  let pow = 0;
  while (max >= 1024 && pow < 5) {
    max /= 1024;
    pow += 1;
  }

  const units = ['bytes', 'KB', 'MB', 'GB', 'TB', 'PB'][pow];
  const bytes = Math.pow(1024, pow);

  return { units, bytes };
}

function renderChart(element, data, { chartType = 'area', yAxisTitle, seriesName, units, dataTransform = x => x } = {}) {
  const chart = new ApexCharts(
    element,
    {
      chart: {
        type: chartType,
        height: 300,
        width: '100%',
        id: `chart-${Math.random().toFixed(10)}`,
        group: 'chart',
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
          text: yAxisTitle,
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
      tooltip: {
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
          formatter: (value) => value ? `${value} ${units}`.trim() : undefined,
          title: {
            formatter: () => '',
          }
        }
      },
      series: [{
        name: seriesName,
        data: dataTransform(data),
      }],
      annotations: window?.annotationsData || {}
    }
  );
  chart.render();
  return chart;
}
