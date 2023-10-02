'use client';
import { connectDevice, Device } from '../../DeviceManager';
import React, { useState } from 'react';
import './SidebarComponent.css'
import { SidebarProps } from './types'

export const SidebarComponent: React.FC<SidebarProps> = ({ devices }) => {
  const [sidebarActive, setSidebarActive] = useState(false);

  const deviceHtml: Array<React.JSX.Element> = [];

  const setError = (message: string) => {
    // TODO: pretty (inline) error messages
    alert(message);
  };

  if (devices != null) {
    for (let i = 0; i < devices.length; ++i) {
      let device = devices[i];

      // TODO: figure out what other data to display when the Device object has more relevant data,
      // if any.
      deviceHtml.push(<div className="device-list-item">
        <h3>Device {device.code}</h3>
        <p>Other useful info goes here</p>
      </div>);
    }
  }

  return (
    <div>
      <button id="expand-sidebar" className="hamburger-button" onClick={() => {
        setSidebarActive(true);
      }}>≡</button>


      <div className={"sidebar " + (sidebarActive ? "" : "hidden")}>
        <div className="right">
          <button id="close-sidebar" className="close-button" onClick={() => {
            setSidebarActive(false);
          }}>x</button>
        </div>
        <div>
          <h2>Connect device</h2>
          <form onSubmit={(ev) => {
            ev.preventDefault();

            let idField = document.getElementById("device-id") as HTMLInputElement;
            let button = document.getElementById("submit-device-id") as HTMLButtonElement;

            let id = idField.value;
            if (id == null || id == "") {
              alert("Please enter an ID");
              return;
            }


            let device = {
              code: id
            } as Device;

            if (devices == null) {
              alert("Programmer error: devices is null");
            } else {
              button.disabled = true;
              connectDevice(devices, device)
                .then(res => {
                  button.disabled = false;
                  if (res == "already_connected") {
                    alert("You're already connected to that device");
                  } else if (res == "ok") {
                    idField.value = "";
                  }
              
                  // This is a disgusting hack
                  setSidebarActive(false);
                  setTimeout(() => {
                    setSidebarActive(true);
                  }, 0);
                });
            }
          }}>
            <label>Enter device ID</label>
            <input id="device-id" name="device-id" placeholder="ABCD1234" />

            <button id="submit-device-id" type="submit">Connect now!</button>
          </form>

          <hr />
          <h2>Device list</h2>

          { deviceHtml.length == 0 ? <p>No devices connected :(</p> : <div className="device-list">{deviceHtml}</div> }
        </div>

      </div>
    </div>
    );
};
