import { ChartComponent } from "@/ChartComponent/ChartComponent";
import { ChartData } from "@/ChartComponent/types";
import React, { useEffect, useState } from "react";
import { PerformanceProps } from "./types";

export const PerformanceComponent: React.FC<PerformanceProps & { pauseOverride: boolean }> = ({
  data,
  pauseOverride,
}) => {
  let [chartData, setChartData] = useState<ChartData[]>([]);
  let [lastExactDate, setLastExactDate] = useState<number>(0);

  useEffect(() => {
    if (data == null) return;
    let now = Date.now();
    let sentAt = Date.parse(data.timestamp);
    if (sentAt > lastExactDate) {
      setLastExactDate(sentAt);
    } else {
      return;
    }

    setChartData((prevData) => {
      let tmp = [
        ...prevData,
        {
          timestamp: new Date(data.timestamp).toLocaleTimeString(),
          datapoint: now - sentAt,
        },
      ];
      if (tmp.length > 100) {
        tmp = tmp.slice(-100);
      }
      return tmp;
    });
  }, [data, chartData, lastExactDate]);

  return (
    <div className="performance-container chart-wrapper">
      <h3>Sensor performance</h3>
      <ChartComponent data={chartData} chartLabel="Ping (ms)" externalPauseValue={pauseOverride} />
    </div>
  );
};
