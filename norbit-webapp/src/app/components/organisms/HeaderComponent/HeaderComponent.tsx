'use client';

import { SidebarProps, SidebarComponent } from "../SidebarComponent/SidebarComponent";
import './HeaderComponent.css'

interface HeaderProps {
  useSidebar: boolean
}

export const HeaderComponent: React.FC<HeaderProps & SidebarProps> = ({ useSidebar, ...props }) => {

  return (
    <header>
      <div className="logo">
        {/* TODO: replace with image */}
        <p>Norbit</p>
      </div>
      <div className="sidebar-button">
        { useSidebar ? <SidebarComponent {...props} /> : ""}
      </div>
    </header>
  );
}
