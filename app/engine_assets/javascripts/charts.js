import ApexCharts from 'apexcharts';

class RailsPerformanceChart extends HTMLElement {
  connectedCallback() {
    this.legend = this.getAttribute('legend');
    this.units = this.getAttribute('units');

    const dataText = this.textContent.trim();
    const data = dataText ? JSON.parse(dataText) : [];
    this.textContent = '';

    const chartDiv = document.createElement('div');
    this.appendChild(chartDiv);

    const type = this.getAttribute('type');
    const renderMethod = this[`render${type}Chart`];
    this.chart = renderMethod.call(this, chartDiv, data);
  }

  updateData(data) {
    this.chart.updateSeries([{ data: data }], false);
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
      units: this.units,
      dataTransform: (data) => {
        return data.map(([timestamp, value]) => {
          return [timestamp, typeof value === 'number' ? (value / bytes).toFixed(2) : null];
        });
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
