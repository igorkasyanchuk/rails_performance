function showTIRChart(div, data) {
  Highcharts.chart(div, {
      time: {
        timezone: 'Europe/Kiev'
      },
      chart: {
          type: 'area',
          zoomType: 'x',
      },
      title: {
          text: ''
      },
      xAxis: {
          crosshair: true,
          type: 'datetime',
          labels: {
            style: {
              color: "#a6b0cf"
            }
          }
      },
      yAxis: {
          min: 0,
          title: {
              text: 'RPM',
              style: {
                color: "#f6f6f6"
              }
          },
          labels: {
            style: {
              color: "#a6b0cf"
            }
          }
      },
      legend: {
          enabled: false
      },
      exporting: {
        buttons: {
          contextButton: {
            theme: {
              fill: "#eee"
            }
          }
        }
      },
      plotOptions: {
          area: {
            color: '#ff5b5b',
          }
      },
      series: [{
          type: 'area',
          name: 'RPM',
          data: data,
          fillOpacity: 0.3,
          lineWidth: 1,
          states: {
            hover: {
              lineWidth: 1
            }
          }
      }]
  });
};

function showRTChart(div, data) {
  Highcharts.chart(div, {
      time: {
        timezone: 'Europe/Kiev'
      },
      chart: {
          type: 'area',
          zoomType: 'x',
      },
      title: {
          text: ''
      },

      tooltip: {
          // positioner: function () {
          //     return {
          //         // right aligned
          //         x: this.chart.chartWidth - this.label.width - 30,
          //         y: 5 // align to title
          //     };
          // },
          borderWidth: 0,
          backgroundColor: 'none',
          pointFormat: '{point.y}',
          //headerFormat: '',
          shadow: false,
          style: {
              fontSize: '16px',
              color: '#000',
          },
          formatter: function() {
              if (this.y == 0) {
                return "";
              }
              return this.y + ' ms';
          }
      },
      xAxis: {
          crosshair: false,
          type: 'datetime',
          labels: {
            style: {
              color: "#a6b0cf"
            }
          }
      },
      yAxis: {
          min: 0,
          title: {
              text: 'Time',
              style: {
                color: "#f6f6f6"
              }
          },
          labels: {
            style: {
              color: "#a6b0cf"
            }
          }
      },
      legend: {
          enabled: false
      },
      exporting: {
        buttons: {
          contextButton: {
            theme: {
              fill: "#eee"
            }
          }
        }
      },
      plotOptions: {
          area: {
            color: '#ff5b5b',
          }
      },
      series: [{
          type: 'area',
          name: 'Response Time',
          data: data,
          fillOpacity: 0.3,
          lineWidth: 1,
          states: {
            hover: {
              lineWidth: 1
            }
          }
      }]
  });
};