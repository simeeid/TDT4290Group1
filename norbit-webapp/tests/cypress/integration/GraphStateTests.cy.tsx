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

        if (bool) {
          ++active;
          cy.get("#" + ids[i]).check();
        } else {
          cy.get("#" + ids[i]).uncheck();
        }
        cy.wait(10000);
      }

      cy.get("#dashboard-chart-container").children().should("have.length", active);
    }
  });
});

export {};
