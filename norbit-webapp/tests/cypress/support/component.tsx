import { mount } from 'cypress/react18'
import { Providers } from '@redux/provider'
import React from 'react';

declare global {
  namespace Cypress {
    interface Chainable {
      mount: typeof mount
    }
  }
}

Cypress.Commands.add('mount', (component, options) => {
  return mount(<Providers>{component}</Providers>, options);
});
