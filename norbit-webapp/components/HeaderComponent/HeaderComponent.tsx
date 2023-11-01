import { Amplify } from "aws-amplify";
import React from "react";

import { SidebarComponent } from "../SidebarComponent/SidebarComponent";
import { SidebarProps } from "../SidebarComponent/types";
import { HeaderProps } from "./types";

export const HeaderComponent: React.FC<HeaderProps & SidebarProps> = ({ useSidebar, ...props }) => {
  const mockAmplify = process.env["NEXT_PUBLIC_MOCK_AMPLIFY"] == "yes";

  return (
    <header>
      <div className="logo">
        {/* TODO: replace with image */}
        <p>Norbit</p>
      </div>
      <div className="sidebar-button">
        {useSidebar ? (
          <SidebarComponent {...props} amplifyInstance={mockAmplify ? null : Amplify} />
        ) : (
          ""
        )}
      </div>
    </header>
  );
};
