import React, { useEffect, useState } from "react";
import { ChartComponent } from "@/ChartComponent/ChartComponent";
import { ChartData } from "@/ChartComponent/types";
import { TamplifyInstance } from "@/Dashboard/Dashboard";
import { useSubscribeToTopics } from "utils/useSubscribeToTopic";
import { TAccelerometerData } from "./types";
import { MockInputComponent } from "@/MockInputComponent/MockInputComponent";

const AccelerometerChart: React.FC<{amplifyInstance: TamplifyInstance | null,topic: string}> = ({amplifyInstance, topic}) => {

  const [data, setData] = useState<ChartData[]>([]);
  const [buffer, setBuffer] = useState<ChartData[]>([]);
  const [isPaused, setIsPaused] = useState(false);
  const [accelerometerData, setAccelerometerData] = useState<TAccelerometerData | null>(null);

  const onPauseStateChange = (newState: boolean) => {
    setIsPaused(newState);
  };

  const transformToChartData = (iotData: any): ChartData => {
    return {
      timestamp: new Date(Date.parse(iotData.timestamp)).toLocaleTimeString(),
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
      {amplifyInstance == null && <MockInputComponent data={data} setData={setData} />}
    </div>
  );
};

export default AccelerometerChart;
