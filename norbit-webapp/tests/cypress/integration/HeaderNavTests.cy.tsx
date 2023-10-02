describe('Header and navbar', () => {
  it('Appears on the homepage', () => {
    cy.visit("/");
    cy.get("div.sidebar").should("exist");
    cy.get("header").should("exist");
  });
});

export {};
