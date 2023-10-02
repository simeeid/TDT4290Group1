export interface Device {
  code: string
}

export async function connectDevice(devices: Array<Device>, device: Device) {
  for (let _device of devices) {
    if (_device.code == device.code) {
      return "already_connected";
    }
  }
  devices.push(device);
  return "ok";
}
