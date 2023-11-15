import { SensorDataFramework } from "@/types";

export type TSoundLevelData = {
  payload: { volume: number };
} & SensorDataFramework;
