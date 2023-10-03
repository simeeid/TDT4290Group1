'use client';

import React, { useEffect, useState } from 'react';
import { ChartData, ChartProps } from './types';
import { LineChart, Line, XAxis, YAxis, Tooltip, Label } from 'recharts';

export const ChartComponent: React.FC<ChartProps> = ({ data, paddingOffset, onPauseStateChange }) => {
  const offset = paddingOffset == null ? 1 : paddingOffset;

  const [isPaused, setIsPaused] = useState(false);
  const [pauseBuffer, setPauseBuffer] = useState<ChartData[]>([]);

  const togglePause = () => {
    if (onPauseStateChange != null) {
      onPauseStateChange(!isPaused);
    }
    setIsPaused(!isPaused);
    console.log(isPaused);
  }

  useEffect(() => {
    if (isPaused && pauseBuffer.length == 0) {
      setPauseBuffer(data);
    } else if (!isPaused && pauseBuffer.length > 0) {
      setPauseBuffer([]);
    }
  }, [isPaused]);
  const minValue = Math.min(...(isPaused ? pauseBuffer.map(item => item.acceleration) : data.map(item => item.acceleration)));
  const maxValue = Math.max(...(isPaused ? pauseBuffer.map(item => item.acceleration) : data.map(item => item.acceleration)));
  return (
    <div className="chart-container">
      <LineChart 
        width={500} 
        height={300} 
        data={isPaused ? pauseBuffer : data}
        margin={{ top: 5, right: 20, bottom: 5, left: 0 }}
      >
        <Line type="monotone" dataKey="acceleration" isAnimationActive={false} stroke="#8884d8" />
        <XAxis dataKey="timestamp" />
        <YAxis domain={[minValue - offset, maxValue + offset]}>
          <Label angle={-90} value="Acceleration" position="insideLeft" style={{textAnchor: 'middle'}} />
        </YAxis>
        <Tooltip />
      </LineChart>
      <button onClick={togglePause}>
        {isPaused ? "Resume" : "Pause"}
      </button>
    </div>
  );
};
