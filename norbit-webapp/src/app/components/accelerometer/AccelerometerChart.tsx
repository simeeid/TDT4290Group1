'use client'
import React, { useEffect, useState } from 'react';
import { AccelerometerData } from './types';
import { LineChart, Line, XAxis, YAxis, Tooltip, Label } from 'recharts';

const AccelerometerChart: React.FC = () => {
  const [data, setData] = useState<AccelerometerData[]>([]);
  const [buffer, setBuffer] = useState<AccelerometerData[]>([]);
  const [isPaused, setIsPaused] = useState(false);

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
  }, [isPaused, buffer]);

  const minValue = Math.min(...data.map(item => item.acceleration), ...buffer.map(item => item.acceleration));
  const maxValue = Math.max(...data.map(item => item.acceleration), ...buffer.map(item => item.acceleration));

  return (
    <div>
      <LineChart 
        width={500} 
        height={300} 
        data={data}
        margin={{ top: 5, right: 20, bottom: 5, left: 0 }}
      >
        <Line type="monotone" dataKey="acceleration" stroke="#8884d8" />
        <XAxis dataKey="timestamp" />
        <YAxis domain={[minValue - 1, maxValue + 1]}>
          <Label angle={-90} value="Acceleration" position="insideLeft" style={{textAnchor: 'middle'}} />
        </YAxis>
        <Tooltip />
      </LineChart>
      <button onClick={() => setIsPaused(!isPaused)}>
        {isPaused ? "Resume" : "Pause"}
      </button>
    </div>
  );
}

export default AccelerometerChart;




