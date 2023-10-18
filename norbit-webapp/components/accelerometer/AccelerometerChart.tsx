import React, { useEffect, useState } from 'react';
import { ChartComponent } from '../ChartComponent/ChartComponent';
import { ChartData } from '../ChartComponent/types';
import { TamplifyInstance } from '@/dashboard/Dashboard';
import { useSubscribeToTopics } from 'utils/useSubscribeToTopic';

const AccelerometerChart: React.FC<{amplifyInstance: TamplifyInstance}> = ({amplifyInstance}) => {
  const [data, setData] = useState<ChartData[]>([]);
  const [buffer, setBuffer] = useState<ChartData[]>([]);
  const [isPaused, setIsPaused] = useState(false);

  // TODO: Handle accelerometer data and proper type declaration
  const [accelerometerData, setAccelerometerData] = useState<any>(0);
 


  

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

  useSubscribeToTopics('accelerometer/topic', amplifyInstance, setAccelerometerData)

  return (
    <div className="sensorContainer">
      <h2>Acceleration</h2>
      <ChartComponent
        data={data}
        onPauseStateChange={onPauseStateChange}
        chartLabel="Acceleration"
      />
    </div>
  );
}

export default AccelerometerChart;




