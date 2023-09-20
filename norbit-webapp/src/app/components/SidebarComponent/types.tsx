import {Device} from '../../DeviceManager';

export interface SidebarProps {
  devices?: Array<Device>,
  connectDevice?: (newDevice: Device) => Promise<boolean>,
}
