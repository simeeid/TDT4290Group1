describe("Device management", () => {
  it("Should allow connections", () => {
    cy.visit("/");
    cy.get("button.hamburger-button").click();
    cy.get(".device-list").should("not.exist");

    for (let i = 0; i < 2; ++i) {
      cy.get("#device-id").should("exist").click().type("example-id-1234");


      cy.get("#submit-device-id").should("exist").click();
      cy.get(".device-list").children().should("have.length", 1);
    }

  });
}); 

export {};
