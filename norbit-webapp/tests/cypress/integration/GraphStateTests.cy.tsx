describe("Graph config", () => {
  it("Should allow charts to be hidden", () => {
    cy.visit("/");
    let ids = [
      "enable-accelerometer",
      "enable-temperature",
      "enable-light",
      "enable-sound",
    ];

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

        let cb = cy.get("#" + ids[i]);
        if (bool) {
          ++active;
          cb.check();
        } else {
          cb.uncheck();
        }
      }


      cy.get("#dashboard-chart-container").children().should("have.length", active);
    }
    


  });
});

export {};
