import { Amplify } from "aws-amplify";

export type TAmplifyInstance = typeof Amplify;

/**
 * Meta interface representing the timestamp type.
 */
export interface Timestamp {
  timestamp: string;
}

/**
 * Common input type for all components that take raw sensor data, and display
 * them.
 */
export interface SensorProps {
  amplifyInstance: TAmplifyInstance | null;
  topic: string;
}

/**
 * Contains the standard fields part of all payloads from the mobile app
 */
export type SensorDataFramework = {
  sensorName: string;
} & Timestamp;
