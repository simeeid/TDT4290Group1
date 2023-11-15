import { SensorDataFramework } from "@/types";

export type TLightIntensityData = {
  payload: { lux: number };
} & SensorDataFramework;
