import ApexCharts from 'apexcharts';

ApexCharts.prototype.updateRollingWindow = function(newData, { windowSizeMs }) {
  let data = this.w.config.series[0].data;

  // drop old points outside of the rolling window
  const windowStart = Date.now() - windowSizeMs;
  while (data.length > 0 && data[0][0] < windowStart) {
    data.shift();
  }

  // create index of remaining data
  const dataMap = new Map();
  data.forEach((point, index) => dataMap.set(point[0], index));
  const lastTimestamp = data.length > 0 ? data[data.length - 1][0] : -Infinity;

  // merge existing data (it can change), append new data
  const pointsToAdd = [];
  newData.forEach(([timestamp, value]) => {
    const index = dataMap.get(timestamp);
    if (index) {
      data[index][1] = value;
    } else if (timestamp > lastTimestamp) {
      pointsToAdd.push([timestamp, value]);
    }
  });
  this.appendData([{ data: pointsToAdd }], false);
};

export default ApexCharts;
