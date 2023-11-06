import { configureStore } from "@reduxjs/toolkit";
import { deviceList } from "./slices/DeviceList";
import { sensorConfig } from "./slices/SensorConfig";

export const store = configureStore({
  reducer: {
    // Active slices go here
    deviceList: deviceList.reducer,
    sensorConfig: sensorConfig.reducer,
  },
  devTools: process.env.NODE_ENV !== "production",
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;
