import React, { useEffect, useState } from 'react';
import { ChartComponent } from '../ChartComponent/ChartComponent';
import { ChartData } from '../ChartComponent/types';
import { TamplifyInstance } from '@/dashboard/Dashboard';
import { useSubscribeToTopics } from 'utils/useSubscribeToTopic';
import { TLightIntensityData } from './types';

export const LightIntensityComponent: React.FC<{ amplifyInstance: TamplifyInstance }> = ({ amplifyInstance }) => {
  const [data, setData] = useState<ChartData[]>([]);
  const [buffer, setBuffer] = useState<ChartData[]>([]);
  const [isPaused, setIsPaused] = useState(false);
  const [lightIntensityData, setLightIntensityData] = useState<TLightIntensityData | null>(null);

  const onPauseStateChange = (newState: boolean) => {
      setIsPaused(newState);
  }

  const transformToChartData = (iotData: any): ChartData => {
      return {
          timestamp: new Date().toLocaleTimeString(),
          datapoint: iotData.payload.lux
      };
  };

  useEffect(() => {
    if (lightIntensityData) {
        const newData = transformToChartData(lightIntensityData);

        setData(prevData => {
            let updatedData;

            // If paused, just append to buffer and do not update the data.
            if (isPaused) {
                setBuffer(prevBuffer => [...prevBuffer, newData]);
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
                updatedData = updatedData.slice(-maxDataPoints);  // Keep the last maxDataPoints
            }

            return updatedData;
        });
    }
}, [lightIntensityData, isPaused]);


  useSubscribeToTopics('lux/topic', amplifyInstance, setLightIntensityData);

  return (
      <div className="sensorContainer">
          <h2>Light Intensity</h2>
          <ChartComponent
              data={data}
              onPauseStateChange={onPauseStateChange}
              chartLabel="Light Intensity"
          />
      </div>
  );
}


