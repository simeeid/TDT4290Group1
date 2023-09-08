import { Button } from "@chakra-ui/react"; 
interface ButtonProps {
  size?: "small" | "medium" | "large";
  onClick?: () => void;
  [key: string]: any;
}

export const ExampleComponent: React.FC<ButtonProps> = ({ children, onClick, size, ...props }) => {

  let fontsize = undefined;
  if (size) {
    if (size === "small") fontsize = 12;
    if (size === "medium") fontsize = 16;
    if (size === "large") fontsize = 20;
  }

  return ( 
    <Button onClick={onClick} bg="teal.300" fontSize={fontsize} {...props}>
      {children}
      </Button>
  );
};
