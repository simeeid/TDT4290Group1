import { configureStore } from "@reduxjs/toolkit";
import { deviceList } from "./slices/DeviceList";

export const store = configureStore({
  reducer: {
    deviceList: deviceList.reducer,
  },
  devTools: process.env.NODE_ENV !== "production",
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;
