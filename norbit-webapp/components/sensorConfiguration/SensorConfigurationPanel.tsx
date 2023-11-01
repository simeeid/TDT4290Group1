'use client'

import {useAppDispatch, useAppSelector} from '@redux/hook';
import {SensorConfig, setState} from '@redux/slices/SensorConfig';
import React from 'react';
import style from './SensorConfigurationPanel.module.css';
import {ConfigProps} from './types';

const SensorConfigurationPanel: React.FC<ConfigProps> = ({amplifyInstance}) => {
  //const [config, setConfig] = useState<SensorConfig>({ accelerometer: true, temperature: true, sound: true, light: true });
  let dispatch = useAppDispatch();
  let config = useAppSelector((state) => state.sensorConfig) as SensorConfig;

  const handleToggle = (sensor: keyof SensorConfig) => {
    let newState = {
      ...config,
      [sensor]: !config[sensor]
    };
    dispatch(
      setState({
        newValue: !config[sensor], 
        field: sensor
      })
    );

    if (amplifyInstance != null) {
      amplifyInstance.PubSub.publish("config/sensor-states",
        {
          ...newState,
          type: "sensor-state-config"
        }
      );
    }
  };

  return (
    <div className= {style.labelBlock} id="sensor-panel">
      <h3>Sensor Configuration</h3>
      {/*
        Note that these blocks are excessively verbose to better accomodate future changes,
        particularly by enabling sane groupings if sensors suddenly get more config (such as
        sampling rate).

        I.e. it's an intentional choice for maintainability
      */}
      <div className={style.configRoot} id="config-root">
        <div className={style.configGroup}>
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

        <div className={style.configGroup}>
          <div className={style.optionGroup}>
            <input 
              id="enable-location"
              type="checkbox"
              checked={config.location}
              onChange={() => handleToggle('location')}
            />
            <label htmlFor="enable-location">Show Location Chart</label>
          </div>
        </div>
        {/* As more sensors are added, you can add more configuration options here */}

      </div>
    </div>
  );
};

export default SensorConfigurationPanel;
