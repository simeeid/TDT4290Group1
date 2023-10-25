import {ChartData} from "@/ChartComponent/types";

export interface MockInputProps {
  data: ChartData[];
  setData: (data: ChartData[]) => void; 
};
