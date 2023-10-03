import {Providers} from '@redux/provider';
import React from 'react';
import { SidebarComponent } from './SidebarComponent';

export default {
  title: "SidebarComponent",
  component: SidebarComponent,
  args: {
  }
};

export const Default = {
  decorators: [
    (story: () => React.ReactNode) => <Providers>{story()}</Providers>,
  ]
};
