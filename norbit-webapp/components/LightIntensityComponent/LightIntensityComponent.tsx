import React, { useEffect, useState } from "react";
import { ChartComponent } from "@/ChartComponent/ChartComponent";
import { ChartData } from "@/ChartComponent/types";
import { TamplifyInstance } from "@/Dashboard/Dashboard";
import { useSubscribeToTopics } from "utils/useSubscribeToTopic";
import { TLightIntensityData } from "./types";
import { MockInputComponent } from "@/MockInputComponent/MockInputComponent";

export const LightIntensityComponent: React.FC<{
  amplifyInstance: TamplifyInstance | null;
  topic: string;
}> = ({ amplifyInstance, topic }) => {
  const [data, setData] = useState<ChartData[]>([]);
  const [buffer, setBuffer] = useState<ChartData[]>([]);
  const [isPaused, setIsPaused] = useState(false);
  const [lightIntensityData, setLightIntensityData] = useState<TLightIntensityData | null>(null);

  const onPauseStateChange = (newState: boolean) => {
    setIsPaused(newState);
  };

  const transformToChartData = (iotData: any): ChartData => {
    return {
      timestamp: new Date(Date.parse(iotData.timestamp)).toLocaleTimeString(),
      datapoint: iotData.payload.lux,
    };
  };

  useEffect(() => {
    if (lightIntensityData) {
      const newData = transformToChartData(lightIntensityData);

      setData((prevData) => {
        let updatedData;

        // If paused, just append to buffer and do not update the data.
        if (isPaused) {
          setBuffer((prevBuffer) => [...prevBuffer, newData]);
          return prevData;
        }

        // If not paused and there's a buffer, filter and append buffer first, then the new data.
        if (buffer.length > 0) {
          const filteredBuffer = buffer.reduce((acc, current) => {
            const previous = acc[acc.length - 1];
            if (!previous || previous.datapoint !== current.datapoint) {
              acc.push(current);
            }
            return acc;
          }, [] as ChartData[]);

          updatedData = [...prevData, ...filteredBuffer, newData];
          setBuffer([]); // Clear the buffer
        } else {
          updatedData = [...prevData, newData];
        }

        // Ensure we're not going beyond the max data points.
        const maxDataPoints = 100;
        if (updatedData.length > maxDataPoints) {
          updatedData = updatedData.slice(-maxDataPoints); // Keep the last maxDataPoints
        }

        return updatedData;
      });
    }
  }, [lightIntensityData, isPaused, buffer]);

  useSubscribeToTopics(topic, amplifyInstance, setLightIntensityData);

  return (
    <div className="sensorContainer" id="light-container">
      <h2>Light sensor</h2>
      <ChartComponent
        data={data}
        onPauseStateChange={onPauseStateChange}
        chartLabel="Brightness (lux)"
      />
      {amplifyInstance == null && <MockInputComponent data={data} setData={setData} />}
    </div>
  );
};
