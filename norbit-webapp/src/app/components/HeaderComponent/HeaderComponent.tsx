'use client';

import { SidebarComponent } from "../SidebarComponent/SidebarComponent";
import { SidebarProps } from '../SidebarComponent/types'

import './HeaderComponent.css'
import {HeaderProps} from "./types"

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
