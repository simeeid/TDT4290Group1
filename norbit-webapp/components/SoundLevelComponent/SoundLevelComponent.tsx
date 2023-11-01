import React, { useEffect, useState } from "react";
import { ChartComponent } from "../ChartComponent/ChartComponent";
import { ChartData } from "../ChartComponent/types";
import { TamplifyInstance } from "@/dashboard/Dashboard";
import { useSubscribeToTopics } from "utils/useSubscribeToTopic";
import { TSoundLevelData } from "./types";
import { MockInputComponent } from "@/MockInputComponent/MockInputComponent";

export const SoundLevelComponent: React.FC<{ amplifyInstance: TamplifyInstance | null }> = ({
  amplifyInstance,
}) => {
  const [data, setData] = useState<ChartData[]>([]);
  const [buffer, setBuffer] = useState<ChartData[]>([]);
  const [isPaused, setIsPaused] = useState(false);
  const [soundLevelData, setSoundLevelData] = useState<TSoundLevelData | null>(null);

  const onPauseStateChange = (newState: boolean) => {
    setIsPaused(newState);
  };

  const transformToChartData = (iotData: any): ChartData => {
    return {
      timestamp: new Date(Date.parse(iotData.timestamp)).toLocaleTimeString(),
      datapoint: iotData.payload.volume,
    };
  };

  useEffect(() => {
    if (soundLevelData) {
      const newData = transformToChartData(soundLevelData);

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
  }, [soundLevelData, isPaused, buffer]);

  useSubscribeToTopics("noise/topic", amplifyInstance, setSoundLevelData);

  return (
    <div className="sensorContainer" id="sound-container">
      <h2>Noise meter</h2>
      <ChartComponent data={data} onPauseStateChange={onPauseStateChange} chartLabel="Noise (dB)" />
      {amplifyInstance == null && <MockInputComponent data={data} setData={setData} />}
    </div>
  );
};
