import React from 'react';
import { HeaderComponent } from '../../../src/app/components/HeaderComponent/HeaderComponent'

describe('Header', () => {
  it("Should render", () => {
    cy.mount(<HeaderComponent useSidebar={false} />);
    cy.get("header").should('exist');
    cy.get("button.hamburger-buttom").should("not.exist");
  });
  it("Should have a sidebar", () => {
    cy.mount(<HeaderComponent useSidebar={true} />);
    cy.get("button.hamburger-button").should("exist");
  });
  it("Should have an expandable sidebar", () => {
    cy.mount(<HeaderComponent useSidebar={true} />);
    cy.get("div.sidebar").should("not.be.visible");
    cy.get("button.hamburger-button").click();
    cy.get("div.sidebar").should("be.visible");
  });
});

export {};
