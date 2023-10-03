import { ChartComponent } from "./ChartComponent";

export default {
  title: "ChartComponent",
  component: ChartComponent,
  args: {
    data: [
      { timestamp: "04:20:00", datapoint: 1 },
      { timestamp: "04:20:01", datapoint: 2 },
      { timestamp: "04:20:02", datapoint: 3 },
      { timestamp: "04:20:03", datapoint: 4 },
      { timestamp: "04:20:04", datapoint: 3 },
      { timestamp: "04:20:05", datapoint: 4 },
      { timestamp: "04:20:06", datapoint: 5 },
    ]
  }
};

export const Default = {};
