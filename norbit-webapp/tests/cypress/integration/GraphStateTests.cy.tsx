describe("Graph config", () => {
  beforeEach(() => {
    cy.visit("/").wait(300);
    cy.get("#signin").click({ force: true });
    cy.get("#expand-sidebar").click();
    cy.get("#device-id").type("a", { force: true });
    cy.get("#submit-device-id").click({ force: true });
    cy.get("#close-sidebar").click();
    //cy.find("#signin").click();
  });

  afterEach(() => {
    cy.get("#signout").click({ force: true });
  });
  //Cypress.config('defaultCommandTimeout', 10000);
  it("Should allow charts to be hidden", () => {
    let ids = ["enable-accelerometer", "enable-light", "enable-sound", "enable-location"];
    cy.get("#expand-sidebar").click();

    // Contains an array of arrays of bools corresponding to checkbox states.
    // This just generates an array of permutations of checkbox states, and
    // generates enough to cover all the IDs.
    let states = [];
    for (let i = 0; i < ids.length * ids.length; ++i) {
      let substate = [] as Array<boolean>;
      for (let j = 0; j < ids.length; ++j) {
        //            vv force number to bool conversion
        substate.push(!!(i & (1 << j)));
      }
      states.push(substate);
    }

    for (const state of states) {
      let active = 0;
      for (let i = 0; i < state.length; ++i) {
        let bool = state[i];

        cy.get("#" + ids[i])
          .scrollIntoView()
          .wait(200);
        cy.get("#" + ids[i]).should("be.visible");
        if (bool) {
          ++active;
          cy.get("#" + ids[i]).check();
        } else {
          cy.get("#" + ids[i]).uncheck();
        }
      }

      cy.get("#dashboard-chart-container").children().should("have.length", active);
    }
  });
});

export {};
