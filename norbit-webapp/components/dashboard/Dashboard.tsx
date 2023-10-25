import React from 'react';
import AccelerometerChart from '../accelerometer/AccelerometerChart';
import dashboardStyles from './Dashboard.module.css';
import { TemperatureComponent } from '../TemperatureComponent/TemperatureComponent';
import { SoundLevelComponent } from '../SoundLevelComponent/SoundLevelComponent';
import { LightIntensityComponent } from '../LightIntensityComponent/LightIntensityComponent';
import { Amplify } from 'aws-amplify';

import { AWSIoTProvider } from '@aws-amplify/pubsub/lib/Providers';
import { useAppSelector } from '@redux/hook';

export type TamplifyInstance = typeof Amplify;

const Dashboard: React.FC = () => {
  let sensorConfig = useAppSelector((state) => state.sensorConfig);

  const config = {
    identityPoolId: process.env.NEXT_PUBLIC_IDENTITY_POOL_ID,
    region: process.env.NEXT_PUBLIC_REGION,
    userPoolId: process.env.NEXT_PUBLIC_USER_POOL_ID,
    userPoolWebClientId: process.env.NEXT_PUBLIC_USER_POOL_WEB_CLIENT_ID,
  };
  console.log(config.userPoolId);

  const mockAmplify = process.env["NEXT_PUBLIC_MOCK_AMPLIFY"] == "yes";

  if (!mockAmplify) {
    console.log("Running Amplify in live mode");
    Amplify.configure(config);
    Amplify.addPluggable(
      new AWSIoTProvider({
        aws_pubsub_region: process.env.NEXT_PUBLIC_REGION,
        aws_pubsub_endpoint: `wss://${process.env.NEXT_PUBLIC_MQTT_ID}/mqtt`,
      })
    );
  } else {
    console.log("Mocking Amplify");
  } 
  return (
    <div className={dashboardStyles.dashboardContainer} id="dashboard-root">
      <div className={dashboardStyles.chartsContainer} id="dashboard-chart-container">
        {sensorConfig.accelerometer && <AccelerometerChart amplifyInstance={mockAmplify ? null : Amplify} />}
        {sensorConfig.temperature && <TemperatureComponent amplifyInstance={mockAmplify ? null : Amplify} />}
        {sensorConfig.light && <LightIntensityComponent amplifyInstance={mockAmplify ? null : Amplify} />}
        {sensorConfig.sound && <SoundLevelComponent amplifyInstance={mockAmplify ? null : Amplify} />}
      </div>
    </div>
  );
};

export default Dashboard;
