export interface ChartData {
  timestamp: string;
  acceleration: number;
};

export interface ChartProps {
  data: ChartData[];
  paddingOffset?: number;
  onPauseStateChange?: (paused: boolean) => void;
};
