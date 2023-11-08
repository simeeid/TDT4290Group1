import { Amplify } from "aws-amplify";
import React from "react";
import { SidebarComponent } from "@/SidebarComponent/SidebarComponent";
import { SidebarProps } from "@/SidebarComponent/types";
import { HeaderProps } from "./types";
import { useSelector } from "react-redux";
import { RootState } from "@redux/store";

export const HeaderComponent: React.FC<HeaderProps & SidebarProps> = ({ useSidebar, ...props }) => {
  const mockAmplify = useSelector((state: RootState) => state.amplify.isMock);
  const user = useSelector((state: RootState) => state.amplify.userName);
  const isAuthenticated = useSelector((state: RootState) => state.amplify.isAuthenticated);

  return (
    <header>
      <div className="logo">
        {/* TODO: replace with image */}
        <span>Norbit</span>
      </div>
      <div className="user-and-menu">
        {isAuthenticated && (
          <div>
            <span>Hello {user}</span>
          </div>
        )}
        <div className="sidebar-button">
          {useSidebar ? (
            <SidebarComponent {...props} amplifyInstance={mockAmplify ? null : Amplify} />
          ) : (
            ""
          )}
        </div>
      </div>
    </header>
  );
};
