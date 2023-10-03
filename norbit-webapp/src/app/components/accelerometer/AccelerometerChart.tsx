'use client'
import React, { useEffect, useState } from 'react';
import { AccelerometerData } from './types';
import { LineChart, Line, XAxis, YAxis, Tooltip, Label } from 'recharts';
import {ChartComponent} from '../ChartComponent/ChartComponent';

const AccelerometerChart: React.FC = () => {
  const [data, setData] = useState<AccelerometerData[]>([]);
  const [buffer, setBuffer] = useState<AccelerometerData[]>([]);
  const [isPaused, setIsPaused] = useState(false);

  const onPauseStateChange = (newState: boolean) => {
    setIsPaused(newState);
  }

  useEffect(() => {
    const generateDummyData = (): AccelerometerData => ({
      timestamp: new Date().toLocaleTimeString(),
      acceleration: parseFloat((Math.random() * 10).toFixed(2))
    });

    const interval = setInterval(() => {
      const newData = generateDummyData();

      if (isPaused) {
        setBuffer(prevBuffer => [...prevBuffer, newData]);
      } else {
        setData(prevData => {
          let updatedData = [...prevData, ...buffer, newData]; // Add buffer data and new data

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
      <h2>Acceleration</h2>
      <ChartComponent
        data={data}
        onPauseStateChange={onPauseStateChange} />
    </div>
  );
}

export default AccelerometerChart;




