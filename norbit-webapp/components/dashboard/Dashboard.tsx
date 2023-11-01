import React, { useEffect, useMemo, useState } from "react";
import AccelerometerChart from "../accelerometer/AccelerometerChart";
import dashboardStyles from "./Dashboard.module.css";
import { SoundLevelComponent } from "../SoundLevelComponent/SoundLevelComponent";
import { LightIntensityComponent } from "../LightIntensityComponent/LightIntensityComponent";
import { Amplify } from "aws-amplify";

import { AWSIoTProvider } from "@aws-amplify/pubsub/lib/Providers";
import { useAppSelector } from "@redux/hook";
import { SensorConfig } from "@redux/slices/SensorConfig";
import dynamic from "next/dynamic";

export type TamplifyInstance = typeof Amplify;


export const MapComponent = dynamic(() => import("@/MapComponent/MapComponent").then((m) => m.MapComponent), {
  ssr: false,
});

const Dashboard: React.FC = () => {
  let sensorConfig = useAppSelector((state) => state.sensorConfig) as SensorConfig;
  let [amplifyEnabled, setAmplifyEnabled] = useState(false);

  const config = useMemo(() => {
    return {
      identityPoolId: process.env.NEXT_PUBLIC_IDENTITY_POOL_ID,
      region: process.env.NEXT_PUBLIC_REGION,
      userPoolId: process.env.NEXT_PUBLIC_USER_POOL_ID,
      userPoolWebClientId: process.env.NEXT_PUBLIC_USER_POOL_WEB_CLIENT_ID,
    };
  }, []);

  const mockAmplify = process.env["NEXT_PUBLIC_MOCK_AMPLIFY"] == "yes";

  useEffect(() => {
    if (!amplifyEnabled) {
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
      setAmplifyEnabled(true);
    }
  }, [amplifyEnabled, mockAmplify, config]);
  return (
    <div className={dashboardStyles.dashboardContainer} id="dashboard-root">
      <div className={dashboardStyles.chartsContainer} id="dashboard-chart-container">
        {sensorConfig.accelerometer && (
          <AccelerometerChart amplifyInstance={mockAmplify ? null : Amplify} />
        )}
        {sensorConfig.light && (
          <LightIntensityComponent amplifyInstance={mockAmplify ? null : Amplify} />
        )}
        {sensorConfig.sound && (
          <SoundLevelComponent amplifyInstance={mockAmplify ? null : Amplify} />
        )}
        {sensorConfig.location && <MapComponent amplifyInstance={mockAmplify ? null : Amplify} />}
      </div>
    </div>
  );
};

export default Dashboard;
