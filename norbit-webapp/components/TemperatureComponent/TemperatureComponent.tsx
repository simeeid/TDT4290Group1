'use client'
import React, { useEffect, useState } from 'react';
import { ChartComponent } from '../ChartComponent/ChartComponent';
import { ChartData } from '../ChartComponent/types';
import { TamplifyInstance } from '@/dashboard/Dashboard';
import { useSubscribeToTopics } from 'utils/useSubscribeToTopic';
import {MockInputComponent} from '@/MockInputComponent/MockInputComponent';

export const TemperatureComponent: React.FC<{amplifyInstance: TamplifyInstance | null, topic : string}> = ({amplifyInstance, topic}) => {
  const [data, setData] = useState<ChartData[]>([]);
  const [buffer, setBuffer] = useState<ChartData[]>([]);
  const [isPaused, setIsPaused] = useState(false);
  // TODO Handle temperature data and proper type declaration 
  const [temperatureData, setTemperatureData] = useState<any>(0);

  const onPauseStateChange = (newState: boolean) => {
    setIsPaused(newState);
  }

  useEffect(() => {
    const generateDummyData = (): ChartData => ({
      timestamp: new Date().toLocaleTimeString(),
      datapoint: parseFloat((Math.random() * 10).toFixed(2))
    });

    const interval = setInterval(() => {
      const newData = generateDummyData();

      if (isPaused) {
        setBuffer(prevBuffer => [...prevBuffer, newData]);
      } else {
        setData(prevData => {
          let updatedData = [...prevData, ...buffer, newData]; 

          // Limit the number of data points displayed
          const maxDataPoints = 100;
          if (updatedData.length > maxDataPoints) {
            updatedData.splice(0, updatedData.length - maxDataPoints); // Remove the oldest entries
          }

          return updatedData;
        });

        if (buffer.length > 0) {
          setBuffer([]); // Empty the buffer
        }
      }
    }, 10);

    return () => clearInterval(interval);
  }, [buffer, isPaused]);

  useSubscribeToTopics(topic, amplifyInstance, setTemperatureData);

  return (
    <div className="sensorContainer" id="temperature-container">
      <h2>Temperature</h2>
      <ChartComponent
        data={data}
        onPauseStateChange={onPauseStateChange}
        chartLabel="Temperature (C)"
      />
      { amplifyInstance == null && <MockInputComponent data={data} setData={setData} /> }
    </div>
  );
}
