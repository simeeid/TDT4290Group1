import { Amplify } from "aws-amplify";
import React from "react";
import { SidebarComponent } from "@/SidebarComponent/SidebarComponent";
import { SidebarProps } from "@/SidebarComponent/types";
import { HeaderProps } from "./types";
import { useDispatch, useSelector } from "react-redux";
import { RootState } from "@redux/store";
import { userSignedOut } from "@redux/slices/amplifySlice";
import { Auth } from "aws-amplify";

export const HeaderComponent: React.FC<HeaderProps & SidebarProps> = ({ useSidebar, ...props }) => {
  const mockAmplify = useSelector((state: RootState) => state.amplify.isMock);
  const isAuthenticated = useSelector((state: RootState) => state.amplify.isAuthenticated);
  const user = useSelector((state: RootState) => state.amplify.userName);
  const dispatch = useDispatch();
  const handleSignOut = async () => {
    if (mockAmplify) {
      console.log("Mock: signing out");
      dispatch(userSignedOut());
      return;
    }
    try {
      await Auth.signOut();
      dispatch(userSignedOut());
    } catch (error) {
      console.error("Error signing out: ", error);
    }
  };

  return (
    <header>
      <div className="logo">
        {/* TODO: replace with image */}
        <p>Norbit</p>
      </div>
      <div className="signout-button">
        {isAuthenticated && (
          <button id="signout" onClick={handleSignOut}>
            Sign Out
          </button>
        )}
      </div>
      <div className="user-and-menu">
        { isAuthenticated &&
          <div>
            <p>Hello {user}</p>
          </div>
        }
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
