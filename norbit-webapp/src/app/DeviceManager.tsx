export interface Device {
  code: string
}

export async function connectDevice(devices: Array<Device>, device: Device) {
  devices.push(device);
  return true;
}
