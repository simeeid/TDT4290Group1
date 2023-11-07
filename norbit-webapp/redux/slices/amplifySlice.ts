import { createSlice } from "@reduxjs/toolkit";

export const amplifySlice = createSlice({
  name: "amplify",
  initialState: {
    initialized: false,
    isMock: process.env["NEXT_PUBLIC_MOCK_AMPLIFY"] == "yes",
    isAuthenticated: false,
    userName: null,
  },
  reducers: {
    setInitialized: (state, action) => {
      state.initialized = action.payload;
    },
    userSignedIn: (state) => {
      state.isAuthenticated = true;
    },
    userSignedOut: (state) => {
      state.isAuthenticated = false;
      state.userName = null;
    },
    setUserName: (state, action) => {
      state.userName = action.payload;
    },
  },
});

export const { setInitialized, userSignedIn, userSignedOut, setUserName } = amplifySlice.actions;

export default amplifySlice.reducer;
