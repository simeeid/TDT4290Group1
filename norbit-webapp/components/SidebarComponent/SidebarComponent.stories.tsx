import { Providers } from "@redux/provider";
import React from "react";
import { SidebarComponent } from "./SidebarComponent";

export default {
  title: "SidebarComponent",
  component: SidebarComponent,
  args: {},
};

export const Default = {
  decorators: [
    // Not sure if there's a better return type here, but this works, so I guess it's fine?
    (story: () => React.ReactNode) => <Providers>{story()}</Providers>,
  ],
};
