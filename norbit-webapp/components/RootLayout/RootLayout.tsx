import React from "react";
import { HeaderComponent } from "components/HeaderComponent/HeaderComponent";
interface Props {
  children: React.ReactNode;
}

const RootLayout: React.FC<Props> = ({ children }) => {
  return (
    <div>
      <HeaderComponent useSidebar={true} />
      {children}
    </div>
  );
};

export default RootLayout;
