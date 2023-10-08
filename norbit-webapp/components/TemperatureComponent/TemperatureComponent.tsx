'use client'
import React, { useEffect, useState } from 'react';
import { ChartComponent } from '../ChartComponent/ChartComponent';
import { ChartData } from '../ChartComponent/types';

export const TemperatureComponent: React.FC = () => {
  const [data, setData] = useState<ChartData[]>([]);
  const [buffer, setBuffer] = useState<ChartData[]>([]);
  const [isPaused, setIsPaused] = useState(false);

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

  return (
    <div className="sensorContainer">
      <h2>Temperature</h2>
      <ChartComponent
        data={data}
        onPauseStateChange={onPauseStateChange}
        chartLabel="Temperature"
      />
    </div>
  );
}
