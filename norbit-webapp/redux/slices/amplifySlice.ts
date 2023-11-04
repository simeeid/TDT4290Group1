// redux/slices/amplifySlice.ts

import { createSlice } from '@reduxjs/toolkit';

export const amplifySlice = createSlice({
  name: 'amplify',
  initialState: {
    initialized: false,
    isMock: process.env["NEXT_PUBLIC_MOCK_AMPLIFY"] == "yes"
  },
  reducers: {
    setInitialized: (state, action) => {
      state.initialized = action.payload;
    },
  },
});

export const { setInitialized } = amplifySlice.actions;

export default amplifySlice.reducer;
