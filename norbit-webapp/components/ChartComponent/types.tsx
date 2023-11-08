export interface ChartData {
  timestamp: string;
  datapoint: number;
}

export interface ChartProps {
  data: ChartData[];
  chartLabel?: string;
  paddingOffset?: number;
  /**
   * Can be used to monitor the component's internal pause state.
   * It's primarily exposed to allow consumers to change their own
   * states when the pause button is pressed.
   *
   * This function can be used to stop or restart the data flow
   */
  onPauseStateChange?: (paused: boolean) => void;
  resolution?: number;
  externalPauseValue?: boolean;
}
