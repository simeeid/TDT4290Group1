import React = require('react');
import { HeaderComponent } from '../../../src/app/components/HeaderComponent/HeaderComponent'

describe('Header', () => {
  it("Should render", () => {
    cy.mount(<HeaderComponent useSidebar={false} />)
  });
});

export {};
