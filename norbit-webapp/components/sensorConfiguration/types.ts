export interface SensorConfig {
  accelerometer: boolean;
  temperature: boolean;
  light: boolean;
  sound: boolean;
  // Other sensors can be added here, e.g., temperature: boolean;
}

export interface Props {
  onConfigurationChange: (config: SensorConfig) => void;
}
