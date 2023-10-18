'use client'

import React, { useState } from 'react';
import style from './SensorConfigurationPanel.module.css';
import { SensorConfig, Props } from './types'; 


const SensorConfigurationPanel: React.FC<Props> = ({ onConfigurationChange }) => {
  const [config, setConfig] = useState<SensorConfig>({ accelerometer: true, temperature: true, sound: true, light: true });

  const handleToggle = (sensor: keyof SensorConfig) => {
    const newConfig = {
      ...config,
      [sensor]: !config[sensor],
    };
    setConfig(newConfig);
    onConfigurationChange(newConfig);
  };

  return (
    <div className= {style.labelBlock} id="sensor-panel">
      <h3>Sensor Configuration</h3>
      <div className={style.configRoot} id="config-root">
        <div className={style.configGroup}>
          <h4>Accelerometer settings</h4>
          <div className={style.optionGroup}>
            <input
              id="enable-accelerometer"
              type="checkbox"
              checked={config.accelerometer}
              onChange={() => handleToggle('accelerometer')}
            />
            <label htmlFor="enable-accelerometer">Show Accelerometer Chart</label>
          </div>
        </div>

        <div className={style.configGroup}>
          <h4>Temperature settings</h4>
          <div className={style.optionGroup}>
            <input 
              id="enable-temperature"
              type="checkbox"
              checked={config.temperature}
              onChange={() => handleToggle('temperature')}
            />
            <label htmlFor="enable-temperature">Show Temperature Chart</label>
          </div>
        </div>

        <div className={style.configGroup}>
          <h4>Light intensity settings</h4>
          <div className={style.optionGroup}>
            <input 
              id="enable-light"
              type="checkbox"
              checked={config.light}
              onChange={() => handleToggle('light')}
            />
            <label htmlFor="enable-light">Show Light Chart</label>
          </div>
        </div>

        <div className={style.configGroup}>
          <h4>Sound level settings</h4>
          <div className={style.optionGroup}>
            <input 
              id="enable-sound"
              type="checkbox"
              checked={config.sound}
              onChange={() => handleToggle('sound')}
            />
            <label htmlFor="enable-sound">Show Sound Level Chart</label>
          </div>
        </div>
        {/* As more sensors are added, you can add more configuration options here */}

      </div>
    </div>
  );
};

export default SensorConfigurationPanel;
