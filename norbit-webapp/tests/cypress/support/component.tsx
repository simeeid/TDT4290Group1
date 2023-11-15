import { mount } from "cypress/react18";
import { Providers } from "@redux/provider";
import React from "react";

import "@styles/globals.css";
import "@styles/HeaderComponent.css";
import "@styles/SidebarComponent.css";

declare global {
  namespace Cypress {
    interface Chainable {
      mount: typeof mount;
    }
  }
}

Cypress.Commands.add("mount", (component, options) => {
  // Wrapping all the components in <Providers> is required
  // for react-redux to work in component tests.
  return mount(<Providers>{component}</Providers>, options);
});
