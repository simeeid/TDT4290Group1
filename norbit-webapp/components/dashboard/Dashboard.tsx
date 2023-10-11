'use client'
import React, { useState } from 'react';
import AccelerometerChart from '../accelerometer/AccelerometerChart';
import SensorConfigurationPanel from '../sensorConfiguration/SensorConfigurationPanel';
import dashboardStyles from './Dashboard.module.css';
import { SensorConfig } from '../sensorConfiguration/types';
import {TemperatureComponent} from '../TemperatureComponent/TemperatureComponent';
import {SoundLevelComponent} from '../SoundLevelComponent/SoundLevelComponent';
import {LightIntensityComponent} from '../LightIntensityComponent/LightIntensityComponent';

const Dashboard: React.FC = () => {
  const [sensorConfig, setSensorConfig] = useState<SensorConfig>({ accelerometer: true, temperature: true, light: true, sound: true });

  return (
    <div className={dashboardStyles.dashboardContainer} id="dashboard-root">
      <div className={dashboardStyles.chartsContainer} id="dashboard-chart-container">
        {sensorConfig.accelerometer && <AccelerometerChart />}
        {sensorConfig.temperature && <TemperatureComponent />}
        {sensorConfig.light && <LightIntensityComponent />}
        {sensorConfig.sound && <SoundLevelComponent />}
      </div>
      <div className={dashboardStyles.configurationPanel}>
        <SensorConfigurationPanel onConfigurationChange={setSensorConfig} />
      </div>
    </div>
  );
};

export default Dashboard;
