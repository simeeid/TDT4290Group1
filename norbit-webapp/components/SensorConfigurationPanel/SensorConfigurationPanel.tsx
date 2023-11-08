import { useAppDispatch, useAppSelector } from "@redux/hook";
import { SensorConfig, setState } from "@redux/slices/SensorConfig";
import React from "react";
import style from "./SensorConfigurationPanel.module.css";
import { ConfigProps } from "./types";

const SensorConfigurationPanel: React.FC<ConfigProps> = ({ amplifyInstance }) => {
  let dispatch = useAppDispatch();
  let config = useAppSelector((state) => state.sensorConfig) as SensorConfig;

  const user = useAppSelector((state) => state.amplify.userName);
  const devices = useAppSelector((state) => state.deviceList.devices);
  const lastConnectedDevice = devices.length > 0 ? devices[devices.length - 1] : null;
  if (lastConnectedDevice == null) {
    return <p>Connect a device to enable sensor config</p>;
  }
  const topic = `${user}/${lastConnectedDevice.code}/config/sensor-states`;

  const handleToggle = (sensor: keyof SensorConfig) => {
    // Dispatch doesn't update `config` for whatever reason, but to ensure this code
    // doesn't misbehave, the new state is stored before dispatch in case the
    // behaviour ever changes to mutate config.
    let newState = {
      ...config,
      [sensor]: !config[sensor],
    };
    dispatch(
      setState({
        newValue: !config[sensor],
        field: sensor,
      })
    );

    if (amplifyInstance != null) {
      amplifyInstance.PubSub.publish("config/sensor-states", {
        ...newState,
        // Required to ensure the client can differentiate between message types.
        // The subscription function in flutter isn't for specific topics, so it just
        // contains everything subscribed to, and filtering is left as an exercise to
        // us. Far from optimal, but it appears to be the only option
        type: "sensor-state-config",
      });
    }
  };

  return (
    <div className={style.labelBlock} id="sensor-panel">
      <h3>Show sensor data</h3>
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
              onChange={() => handleToggle("accelerometer")}
            />
            <label htmlFor="enable-accelerometer">Accelerometer</label>
          </div>
        </div>

        <div className={style.configGroup}>
          <div className={style.optionGroup}>
            <input
              id="enable-light"
              type="checkbox"
              checked={config.light}
              onChange={() => handleToggle("light")}
            />
            <label htmlFor="enable-light">Light</label>
          </div>
        </div>

        <div className={style.configGroup}>
          <div className={style.optionGroup}>
            <input
              id="enable-sound"
              type="checkbox"
              checked={config.sound}
              onChange={() => handleToggle("sound")}
            />
            <label htmlFor="enable-sound">Noise meter</label>
          </div>
        </div>

        <div className={style.configGroup}>
          <div className={style.optionGroup}>
            <input
              id="enable-location"
              type="checkbox"
              checked={config.location}
              onChange={() => handleToggle("location")}
            />
            <label htmlFor="enable-location">Location</label>
          </div>
        </div>
        {/* As more sensors are added, you can add more configuration options here */}
      </div>
    </div>
  );
};

export default SensorConfigurationPanel;
