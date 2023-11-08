import React, { useEffect, useState } from "react";
import { ChartComponent } from "@/ChartComponent/ChartComponent";
import { ChartData, ChartProps } from "@/ChartComponent/types";
import { useSubscribeToTopics } from "utils/useSubscribeToTopic";
import { TAccelerometerData } from "./types";
import { MockInputComponent } from "@/MockInputComponent/MockInputComponent";
import { SensorProps } from "@/types";
import {PerformanceComponent} from "@/PerformanceComponent/PerformanceComponent";

const AccelerometerChart: React.FC<SensorProps> = ({ amplifyInstance, topic }) => {
  const [data, setData] = useState<ChartData[]>([]);
  const [buffer, setBuffer] = useState<ChartData[]>([]);
  const [isPaused, setIsPaused] = useState(false);
  const [accelerometerData, setAccelerometerData] = useState<TAccelerometerData | null>(null);

  const onPauseStateChange = (paused: boolean) => {
    setIsPaused(paused);
  }

  const transformToChartData = (iotData: TAccelerometerData): ChartData => {
    return {
      timestamp: new Date(Date.parse(iotData.timestamp)).toLocaleTimeString(),
      // This converts the input values to a single, combined acceleration value.
      // Note that by default, this will resolve to 9.81m/s^2, as the accelerometer
      // includes gravity acceleration while standing still, tech.
      datapoint: Math.sqrt(
        iotData.payload.x * iotData.payload.x +
          iotData.payload.y * iotData.payload.y +
          iotData.payload.z * iotData.payload.z
      ),
    };
  };

  useEffect(() => {
    if (accelerometerData) {
      const newData = transformToChartData(accelerometerData);

      setData((prevData) => {
        let updatedData;

        if (isPaused) {
          setBuffer((prevBuffer) => [...prevBuffer, newData]);
          return prevData;
        }

        // Filter buffer to remove consecutive duplicates
        const filteredBuffer = buffer.reduce((acc, current) => {
          const previous = acc[acc.length - 1];
          if (!previous || previous.datapoint !== current.datapoint) {
            acc.push(current);
          }
          return acc;
        }, [] as ChartData[]);

        updatedData = [...prevData, ...filteredBuffer, newData];

        // Limit the number of data points displayed
        const maxDataPoints = 100;
        if (updatedData.length > maxDataPoints) {
          updatedData = updatedData.slice(-maxDataPoints); // Keep the last maxDataPoints
        }

        if (buffer.length > 0) {
          setBuffer([]); // Clear the buffer
        }

        return updatedData;
      });
    }
  }, [accelerometerData, isPaused, buffer]);

  useSubscribeToTopics(topic, amplifyInstance, setAccelerometerData);

  return (
    <div className="sensorContainer" id="acceleration-container">
      <h2>Accelerometer</h2>
      <ChartComponent
        data={data}
        onPauseStateChange={onPauseStateChange}
        chartLabel="Acceleration (m/s^2)"
      />
      <PerformanceComponent data={accelerometerData} />
      {amplifyInstance == null && <MockInputComponent data={data} setData={setData} />}
    </div>
  );
};

export default AccelerometerChart;
