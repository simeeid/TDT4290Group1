'use client'
import React, { useState } from 'react';
import style from './SensorConfigurationPanel.module.css';
import { SensorConfig,Props } from './types'; 



const SensorConfigurationPanel: React.FC<Props> = ({ onConfigurationChange }) => {
  const [config, setConfig] = useState<SensorConfig>({ accelerometer: true, temperature: true });

  const handleToggle = (sensor: keyof SensorConfig) => {
    const newConfig = {
      ...config,
      [sensor]: !config[sensor],
    };
    setConfig(newConfig);
    onConfigurationChange(newConfig);
  };

  return (
    <div className= {style.labelBlock} >
      <h3>Sensor Configuration</h3>
      <div>
        <label>
          <input 
            type="checkbox"
            checked={config.accelerometer}
            onChange={() => handleToggle('accelerometer')}
          />
          Show Accelerometer Chart
        </label>

        <label>
        <input 
          type="checkbox"
          checked={config.temperature}
          onChange={() => handleToggle('temperature')}
        />
        Show Temperature Chart
      </label>

        
      </div>
      {/* As more sensors are added, you can add more configuration options here */}
    </div>
  );
};

export default SensorConfigurationPanel;
