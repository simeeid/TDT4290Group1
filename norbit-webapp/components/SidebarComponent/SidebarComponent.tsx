"use client";
import { connectDevice, Device } from "@/DeviceManager";
import React, { useState } from "react";

import { RootState } from "@redux/store";
import { Auth } from "aws-amplify";
import { SidebarProps } from "./types";
import { useAppDispatch, useAppSelector } from "@redux/hook";
import { push } from "@redux/slices/DeviceList";
import SensorConfigurationPanel from "@/SensorConfigurationPanel/SensorConfigurationPanel";
import { userSignedOut } from "@redux/slices/amplifySlice";

export const SidebarComponent: React.FC<SidebarProps> = ({ amplifyInstance }) => {
  let dispatch = useAppDispatch();
  let devices = useAppSelector((state) => state.deviceList.devices);
  const mockAmplify = useAppSelector((state: RootState) => state.amplify.isMock);
  const isAuthenticated = useAppSelector((state: RootState) => state.amplify.isAuthenticated);
  const user = useAppSelector((state) => state.amplify.userName);

  const [sidebarActive, setSidebarActive] = useState(false);

  const deviceHtml: Array<React.JSX.Element> = [];

  const setError = (message: string) => {
    // TODO: pretty (inline) error messages
    alert(message);
  };

  if (devices != null && devices.length > 0) {
    //for (let i = 0; i < devices.length; ++i) {
    //let device = devices[i];

    //// TODO: figure out what other data to display when the Device object has more relevant data,
    //// if any.
    //deviceHtml.push(
    //<li>{device.code}</li>
    //);
    //}

    // Since we only have time to support a single connection, only display that one connection
    deviceHtml.push(<li>{devices[devices.length - 1].code}</li>);
  }

  const handleSignOut = async () => {
    if (mockAmplify) {
      console.log("Mock: signing out");
      dispatch(userSignedOut());
      return;
    }
    try {
      await Auth.signOut();
      dispatch(userSignedOut());
    } catch (error) {
      console.error("Error signing out: ", error);
    }
  };

  return (
    <div>
      <button
        id="expand-sidebar"
        className="hamburger-button"
        onClick={() => {
          setSidebarActive(true);
        }}
      >
        ≡
      </button>

      <div className={"sidebar " + (sidebarActive ? "" : "hidden")}>
        <div className="right">
          <button
            id="close-sidebar"
            className="close-button"
            onClick={() => {
              setSidebarActive(false);
            }}
          >
            x
          </button>
        </div>
        <div>
          <h2>Connect device</h2>
          <form
            onSubmit={(ev) => {
              ev.preventDefault();

              let idField = document.getElementById("device-id") as HTMLInputElement;
              let button = document.getElementById("submit-device-id") as HTMLButtonElement;

              let id = idField.value;
              if (id == null || id == "") {
                setError("Please enter an ID");
                return;
              }

              let device = {
                code: id,
              } as Device;

              if (devices == null) {
                setError("Programmer error: devices is null");
              } else {
                button.disabled = true;
                connectDevice(devices, () => dispatch(push(device)), device).then((res) => {
                  button.disabled = false;
                  if (res == "already_connected") {
                    setError("You're already connected to that device");
                  } else if (res == "ok") {
                    idField.value = "";
                  }
                });
              }
            }}
          >
            <label htmlFor="device-id">Enter device ID</label>
            <input id="device-id" name="device-id" placeholder="ABCD1234" />

            <button id="submit-device-id" className="norbit-primary" type="submit">
              Connect now!
            </button>
          </form>

          <hr />
          <h2>Device list</h2>

          {deviceHtml.length == 0 ? (
            <p>No devices connected :(</p>
          ) : (
            <ul className="device-list">{deviceHtml}</ul>
          )}
        </div>
        <div className="configurationPanel">
          <SensorConfigurationPanel amplifyInstance={amplifyInstance} />
        </div>
        <div className="account-management">
          {isAuthenticated && (
            <>
              <h2>Account management</h2>
              <p>You are currently logged in as {user}</p>
              <button id="signout" className="norbit-primary" onClick={handleSignOut}>
                Sign Out
              </button>
            </>
          )}
        </div>
      </div>
    </div>
  );
};
