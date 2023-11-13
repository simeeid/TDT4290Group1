import { SensorDataFramework } from "@/types";

export type TAccelerometerData = {
  payload: { x: number; y: number; z: number };
} & SensorDataFramework;
