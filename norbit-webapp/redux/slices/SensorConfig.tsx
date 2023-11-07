import { createSlice, PayloadAction } from "@reduxjs/toolkit";

export interface SensorConfig {
  accelerometer: boolean;
  light: boolean;
  sound: boolean;
  location: boolean;
  // Other sensors can be added here, e.g., temperature: boolean;
}

export const sensorConfig = createSlice({
  name: "sensorConfig",
  initialState: {
    accelerometer: true,
    light: true,
    sound: true,
    location: true,
  },
  reducers: {
    setState: (state, payload: PayloadAction<{ newValue: boolean; field: keyof SensorConfig }>) => {
      state[payload.payload.field] = payload.payload.newValue;
    },
  },
});

export const { setState } = sensorConfig.actions;

export default sensorConfig.reducer;
