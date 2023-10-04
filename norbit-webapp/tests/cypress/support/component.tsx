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
  // Wrapping all the components in <Providers> is required
  // for react-redux to work in component tests.
  return mount(<Providers>{component}</Providers>, options);
});
