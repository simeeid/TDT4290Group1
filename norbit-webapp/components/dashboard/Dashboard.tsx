import React, {useEffect, useMemo, useState} from 'react';
import AccelerometerChart from '../accelerometer/AccelerometerChart';
import dashboardStyles from './Dashboard.module.css';
import { TemperatureComponent } from '../TemperatureComponent/TemperatureComponent';
import { SoundLevelComponent } from '../SoundLevelComponent/SoundLevelComponent';
import { LightIntensityComponent } from '../LightIntensityComponent/LightIntensityComponent';
import { Amplify } from 'aws-amplify';
import { useAppSelector } from '@redux/hook';
import { SensorConfig } from '@redux/slices/SensorConfig';
import { MapComponent } from '@/MapComponent/MapComponent';

export type TamplifyInstance = typeof Amplify;

const Dashboard: React.FC = () => {
  let sensorConfig = useAppSelector((state) => state.sensorConfig) as SensorConfig;
  const mockAmplify = useAppSelector((state) => state.amplify.isMock);

  return (
    <div className={dashboardStyles.dashboardContainer} id="dashboard-root">
      <div className={dashboardStyles.chartsContainer} id="dashboard-chart-container">
        {sensorConfig.accelerometer && <AccelerometerChart amplifyInstance={mockAmplify ? null : Amplify} />}
        {sensorConfig.temperature && <TemperatureComponent amplifyInstance={mockAmplify ? null : Amplify} />}
        {sensorConfig.light && <LightIntensityComponent amplifyInstance={mockAmplify ? null : Amplify} />}
        {sensorConfig.sound && <SoundLevelComponent amplifyInstance={mockAmplify ? null : Amplify} />}
        {sensorConfig.location && <MapComponent amplifyInstance={mockAmplify ? null : Amplify} />}
      </div>
    </div>
  );
};

export default Dashboard;
