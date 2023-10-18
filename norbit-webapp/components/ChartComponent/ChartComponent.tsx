'use client';

import React, { useEffect, useState } from 'react';
import { ChartData, ChartProps } from './types';
import { LineChart, Line, XAxis, YAxis, Tooltip, Label } from 'recharts';

export const ChartComponent: React.FC<ChartProps> = ({ data, chartLabel, paddingOffset, onPauseStateChange }) => {
  const offset = paddingOffset == null ? 1 : paddingOffset;

  const [isPaused, setIsPaused] = useState(false);
  const [pauseBuffer, setPauseBuffer] = useState<ChartData[]>([]);

  const togglePause = () => {
    if (onPauseStateChange != null) {
      onPauseStateChange(!isPaused);
    }
    setIsPaused(!isPaused);
  };

  useEffect(() => {
    if (isPaused && pauseBuffer.length == 0) {
      setPauseBuffer(data);
    } else if (!isPaused && pauseBuffer.length > 0) {
      setPauseBuffer([]);
    }
  }, [isPaused, data, pauseBuffer]);
  const minValue = Math.min(...(isPaused ? pauseBuffer.map(item => item.datapoint) : data.map(item => item.datapoint)));
  const maxValue = Math.max(...(isPaused ? pauseBuffer.map(item => item.datapoint) : data.map(item => item.datapoint)));
  return (
    <div className="chart-container">
      <LineChart 
        width={500} 
        height={300} 
        data={isPaused ? pauseBuffer : data}
        margin={{ top: 5, right: 20, bottom: 5, left: 0 }}
      >
        <Line type="monotone" dataKey="datapoint" isAnimationActive={false} stroke="#8884d8" />
        <XAxis dataKey="timestamp" />
        <YAxis domain={[minValue - offset, maxValue + offset]}>
          {chartLabel ? <Label angle={-90} value={chartLabel} position="insideLeft" style={{textAnchor: 'middle'}} /> : ""}
        </YAxis>
        <Tooltip />
      </LineChart>
      <button className="light" onClick={togglePause}>
        {isPaused ? "Resume" : "Pause"}
      </button>
    </div>
  );
};
