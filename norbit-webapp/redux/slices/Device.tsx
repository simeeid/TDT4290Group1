import { createSlice } from "@reduxjs/toolkit"

export interface Device {
  code: string
}

export const devicesList = createSlice({
  name: 'devices',
  initialState: {
    devices: [] as Array<Device>
  },
  reducers: {}
});

export default devicesList.reducer;
