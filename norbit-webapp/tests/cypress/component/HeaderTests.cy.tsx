import React from 'react';
import { HeaderComponent } from '@/HeaderComponent/HeaderComponent'

describe('Header', () => {
  it("Should render", () => {
    cy.mount(<HeaderComponent useSidebar={false} />);
    cy.get("header").should('exist');
    // Make sure both the navbar integration and the entire sidebar component is excluded
    cy.get("button.hamburger-buttom").should("not.exist");
    cy.get("div.sidebar").should("not.exist");
  });
  it("Should have a sidebar", () => {
    cy.mount(<HeaderComponent useSidebar={true} />);
    cy.get("button.hamburger-button").should("exist");
  });
  it("Should have an expandable sidebar", () => {
    cy.mount(<HeaderComponent useSidebar={true} />);
    // Not sure if be.visible and not.be.visible are good enough, but they seem to work before
    // and after. There might be an edge-case where a bug causes be.visible to be true, even if it
    // isn't actually visible in practice, but that should be a regression test instead.
    cy.get("div.sidebar").should("not.be.visible");
    cy.get("button.hamburger-button").click();
    cy.get("div.sidebar").should("be.visible");
  });
});

export {};
