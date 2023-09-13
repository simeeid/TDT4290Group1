import { SidebarComponent } from "../SidebarComponent/SidebarComponent";
import './HeaderComponent.css'

interface HeaderProps {
    hasSidebar: boolean
}

export const HeaderComponent: React.FC<HeaderProps> = ({ hasSidebar, ...props }) => {

    return (
        <header>
            <div className="logo">
                {/* TODO: replace with image */}
                <p>Norbit</p>
            </div>
            <div className="sidebar-button">
                { hasSidebar ? <SidebarComponent {...props} /> : ""}
            </div>
        </header>
    );
}
