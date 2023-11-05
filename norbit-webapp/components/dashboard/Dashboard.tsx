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
  const user = useAppSelector((state) => state.amplify.userName);
  const devices = useAppSelector((state) => state.deviceList.devices);
  const lastConnectedDevice = devices[devices.length - 1];


  if (!lastConnectedDevice) {
    return (
      <div className={dashboardStyles.dashboardContainer} id="dashboard-root">
        <div className={dashboardStyles.chartsContainer} id="dashboard-chart-container">
          <h1>Connect a device to see data</h1>
        </div>
      </div>
    );
    
  }
  const accelerometerTopic = `${user}/${lastConnectedDevice.code}/accelerometer`;
  const temperatureTopic = `${user}/${lastConnectedDevice.code}/temperature`;
  const lightTopic = `${user}/${lastConnectedDevice.code}/lux`;
  const soundTopic = `${user}/${lastConnectedDevice.code}/volume`;
  const locationTopic = `${user}/${lastConnectedDevice.code}/location`;

  return (
    <div className={dashboardStyles.dashboardContainer} id="dashboard-root">
      <div className={dashboardStyles.chartsContainer} id="dashboard-chart-container">
        {sensorConfig.accelerometer && <AccelerometerChart topic={accelerometerTopic} amplifyInstance={mockAmplify ? null : Amplify} />}
        {sensorConfig.temperature && <TemperatureComponent topic={temperatureTopic} amplifyInstance={mockAmplify ? null : Amplify} />}
        {sensorConfig.light && <LightIntensityComponent topic={lightTopic} amplifyInstance={mockAmplify ? null : Amplify} />}
        {sensorConfig.sound && <SoundLevelComponent topic={soundTopic} amplifyInstance={mockAmplify ? null : Amplify} />}
        {sensorConfig.location && <MapComponent topic={locationTopic} amplifyInstance={mockAmplify ? null : Amplify} />}
      </div>
    </div>
  );
};

export default Dashboard;
