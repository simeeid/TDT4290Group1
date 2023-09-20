'use client'
import React, { useState } from 'react';
import AccelerometerChart from '../accelerometer/AccelerometerChart';
import SensorConfigurationPanel from '../sensorConfiguration/SensorConfigurationPanel';
import dashboadStyles from './Dashboard.module.css';
import { SensorConfig } from '../sensorConfiguration/types';
const Dashboard: React.FC = () => {
  const [sensorConfig, setSensorConfig] = useState<SensorConfig>({ accelerometer: true, temperature: true });

  return (
    <div className={dashboadStyles.dashboardContainer}>
      <div className={dashboadStyles.chartsContainer}>
        {sensorConfig.accelerometer && <AccelerometerChart />}
        {sensorConfig.temperature && <div>Tempreture</div>}
      </div>
      <div className={dashboadStyles.configurationPanel}>
        <SensorConfigurationPanel onConfigurationChange={setSensorConfig} />
      </div>
    </div>
  );
};

export default Dashboard;
