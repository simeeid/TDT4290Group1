import {SensorConfig} from "@redux/slices/SensorConfig";

export interface Props {
  onConfigurationChange: (config: SensorConfig) => void;
  config: SensorConfig;
}
