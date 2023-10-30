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
  it("Should contain sensor config", () => {
    cy.mount(<HeaderComponent useSidebar={true} />);
    cy.get("div.sidebar").should("not.be.visible");
    cy.get("button.hamburger-button").click();
    cy.get("div.sidebar").should("be.visible");
    cy.get("#sensor-panel")
      .should("exist")
      .and("be.visible");
  });
  it("Should have scroll when overflowing", () => {
    cy.mount(<HeaderComponent useSidebar={true} />);
    cy.get("div.sidebar").should("not.be.visible");
    cy.get("button.hamburger-button").click();
    cy.get("div.sidebar").should("be.visible");

    // Sufficiently large (well, excesssively in this test) viewport: no overflow
    cy.viewport(600, 8000);
    cy.get("div.sidebar")
      .invoke("outerHeight")
      .should("eq", 8000);
    cy.get("div.sidebar")
      .invoke("prop", "scrollHeight")
      .should("eq", 8000);
    cy.get("div.sidebar")
      .invoke("outerHeight")
      .should("eq", 8000);

    // Tiny viewport: div should overflow
    cy.viewport(600, 80);
    cy.get("div.sidebar")
      .invoke("outerHeight")
      .should("eq", 80);
    cy.get("div.sidebar")
      .invoke("prop", "scrollHeight")
      .should("be.greaterThan", 80);

  })
});

export {};
