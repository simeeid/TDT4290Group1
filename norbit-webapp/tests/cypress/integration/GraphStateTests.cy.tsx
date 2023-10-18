describe("Graph config", () => {
  Cypress.config('defaultCommandTimeout', 10000);
  it("Should allow charts to be hidden", () => {
    cy.visit("/");
    let ids = [
      "enable-accelerometer",
      "enable-temperature",
      "enable-light",
      "enable-sound",
    ];

    // Contains an array of arrays of bools corresponding to checkbox states.
    // This just generates an array of permutations of checkbox states, and 
    // generates enough to cover all the IDs.
    let states = [];
    for (let i = 0; i < ids.length * ids.length; ++i) {
      let substate = [] as Array<boolean>;
      for (let j = 0; j < ids.length; ++j) {
        //            vv force number to bool conversion
        substate.push(!!(i & 1 << j));
      }
      states.push(substate);
    }

    for (const state of states) {
      let active = 0;
      for (let i = 0; i < state.length; ++i) {
        let bool = state[i];

        cy.get("#" + ids[i]).as("cb");
        if (bool) {
          ++active;
          cy.get("@cb").check();
        } else {
          cy.get("@cb").uncheck();
        }
      }

      cy.get("#dashboard-chart-container").children().should("have.length", active);
      cy.wait(1500);
    }
  });
});

export {};
