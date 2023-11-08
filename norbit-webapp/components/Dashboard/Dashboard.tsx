import AccelerometerChart from "@/AccelerometerChart/AccelerometerChart";
import dashboardStyles from "./Dashboard.module.css";
import { SoundLevelComponent } from "@/SoundLevelComponent/SoundLevelComponent";
import { LightIntensityComponent } from "@/LightIntensityComponent/LightIntensityComponent";
import { Amplify } from "aws-amplify";
import React from "react";

import { useAppSelector } from "@redux/hook";
import { SensorConfig } from "@redux/slices/SensorConfig";
import dynamic from "next/dynamic";

export type TamplifyInstance = typeof Amplify;

/**
 * Dynamic wrapper around MapComponent to allow for fully client-sided rendering of the MapComponent.
 * This is required because Leaflet is a client-sided libarry, but next.js is server-sided.
 * INdividual components withint MapComponent could be made dynamic instead, but unfortunately, this
 * doesn't seem to extend to functions like `useMap`, which still break.
 */
export const MapComponent = dynamic(
  () => import("@/MapComponent/MapComponent").then((m) => m.MapComponent),
  {
    ssr: false,
  }
);

const Dashboard: React.FC = () => {
  let sensorConfig = useAppSelector((state) => state.sensorConfig) as SensorConfig;
  const mockAmplify = useAppSelector((state) => state.amplify.isMock);
  const user = useAppSelector((state) => state.amplify.userName);
  const devices = useAppSelector((state) => state.deviceList.devices);
  const lastConnectedDevice = devices.length > 0 ? devices[devices.length - 1] : null;

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
  const lightTopic = `${user}/${lastConnectedDevice.code}/lux`;
  const soundTopic = `${user}/${lastConnectedDevice.code}/noise`;
  const locationTopic = `${user}/${lastConnectedDevice.code}/location`;

  return (
    <div className={dashboardStyles.dashboardContainer} id="dashboard-root">
      <div className={dashboardStyles.chartsContainer} id="dashboard-chart-container">
        {sensorConfig.accelerometer && (
          <AccelerometerChart
            topic={accelerometerTopic}
            amplifyInstance={mockAmplify ? null : Amplify}
          />
        )}
        {sensorConfig.light && (
          <LightIntensityComponent
            topic={lightTopic}
            amplifyInstance={mockAmplify ? null : Amplify}
          />
        )}
        {sensorConfig.sound && (
          <SoundLevelComponent topic={soundTopic} amplifyInstance={mockAmplify ? null : Amplify} />
        )}
        {sensorConfig.location && (
          <MapComponent topic={locationTopic} amplifyInstance={mockAmplify ? null : Amplify} />
        )}
      </div>
    </div>
  );
};

export default Dashboard;
