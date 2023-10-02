'use client';

import { Device } from '@redux/slices/DeviceList'

export async function connectDevice(devices: Array<Device>, push: (device: Device) => void, device: Device) {

  for (let _device of devices) {
    if (_device.code == device.code) {
      return "already_connected";
    }
  }
  push(device);
  return "ok";
}

export type { Device };
