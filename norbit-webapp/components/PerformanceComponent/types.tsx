import { Timestamp } from "@/types";

export interface PerformanceData {
  arrivalTimestamp: number;
}

export interface PerformanceProps {
  data: Array<Timestamp & PerformanceData>;
}
