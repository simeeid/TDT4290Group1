import { SensorDataFramework } from "@/types";

export interface MapData {
  latitude: number;
  longitude: number;
}

export type TLocationData = {
  payload: MapData;
} & SensorDataFramework;
