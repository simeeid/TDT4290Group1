import { createSlice, PayloadAction } from "@reduxjs/toolkit"

export interface Device {
  code: string
}

export const deviceList = createSlice({
  name: 'devices',
  initialState: {
    devices: [] as Array<Device>
  },
  reducers: {
    push: (state, dev: PayloadAction<Device>) => {
      state.devices.push(dev.payload);
    },
    pop: (state, dev: PayloadAction<Device>) => {
      let idx = 0;
      let found = false;

      for (let device of state.devices) {
        if (device.code == dev.payload.code) {
          found = true;
          break;
        }
        ++idx;
      }
      if (!found) {
        return;
      }

      delete state.devices[idx];
    }
  }
});

export default deviceList.reducer;
