import React from "react";

interface Props {
  children: React.ReactNode;
}

const RootLayout: React.FC<Props> = ({ children }) => {
  return <div>{children}</div>;
};

export default RootLayout;
