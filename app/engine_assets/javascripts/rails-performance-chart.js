import { showTIRChart, showRTChart, showPercentageChart, showUsageChart } from 'rails_performance/charts';

class RailsPerformanceChart extends HTMLElement {
  connectedCallback() {
    const type = this.getAttribute('type');
    const legend = this.getAttribute('legend');
    const units = this.getAttribute('units');
    const dataText = this.textContent.trim();
    const data = dataText ? JSON.parse(dataText) : [];

    const chartDiv = document.createElement('div');
    this.textContent = '';
    this.appendChild(chartDiv);

    this.chart = this.renderChart(chartDiv, type, legend, units, data);
  }

  updateData(data) {
    this.chart.updateSeries([{ data: data }], false);
  }

  renderChart(element, type, legend, units, data) {
    switch(type) {
      case 'TIR':
        return showTIRChart(element, data, units, legend);
      case 'RT':
        return showRTChart(element, data);
      case 'Percentage':
        return showPercentageChart(element, data, legend);
      case 'Usage':
        return showUsageChart(element, data, legend);
      default:
        console.error(`Unknown chart type: ${type}`);
        return null;
    }
  }
}

customElements.define('rails-performance-chart', RailsPerformanceChart);
