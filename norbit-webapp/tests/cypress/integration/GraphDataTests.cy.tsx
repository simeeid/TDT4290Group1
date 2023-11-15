describe("Numeric graphs", () => {
  let graphIds = [
    "acceleration-container",
    // Temperature chart tests are disabled for now, due to it still using dummy data
    //"temperature-container",
    "sound-container",
    "light-container",
  ];

  const insertMockData = (id: string, data: number) => {
    cy.get(id + " > input")
      .first()
      .should("exist")
      // force: true is required, as the field is invisible (which itself is a nasty hack)
      .type(data + "{enter}", { force: true });
  };

  beforeEach(() => {
    cy.visit("/").wait(300);
    cy.get("#signin").click({ force: true });
    cy.get("#expand-sidebar").click();
    cy.get("#device-id").type("a", { force: true });
    cy.get("#submit-device-id").click({ force: true });
    cy.get("#close-sidebar").click();
  });

  afterEach(() => {
    cy.get("#signout").click({ force: true });
  });

  // Note: if this test fails, you've failed to, or incorrectly set, the
  // NEXT_PUBLIC_MOCK_AMPLIFY variable to "yes" before running the server.
  // See norbit-webapp/README.md for more information. Failure to set this variable
  // will result in many integration tests being flaky, or outright failing to run.
  it("should contain, but not show the hidden mock input element", () => {
    for (const id of graphIds) {
      const htmlId = "#" + id;
      cy.get(htmlId).should("exist");
      cy.get(htmlId + " > input")
        .first()
        .should("exist")
        .and("not.be.visible");
    }
  });
  it("should render the graph on the page", () => {
    for (const id of graphIds) {
      const htmlId = "#" + id;
      cy.get(htmlId).should("exist");
      cy.get(htmlId).find(".recharts-wrapper").should("exist").and("be.visible");
    }
  });
  it("should render the data", () => {
    // Insert data
    let dataStart = 0;
    for (const id of graphIds) {
      const htmlId = "#" + id;
      for (let i = 0; i < 5; ++i) {
        insertMockData(htmlId, dataStart);
        ++dataStart;
      }
    }

    cy.wait(300);

    let chartIdx = 0;
    for (const id of graphIds) {
      const htmlId = "#" + id;
      // Assert the size is as expected
      cy.get(htmlId + " .recharts-line-dots")
        .children()
        .should("have.length", 5);
      // The index represents the data ID, as the label is used is just the length of the data
      // at the time of insertion.
      for (let i = 0; i < 5; ++i) {
        // Compute the value of this point. Eachc chart tested is guaranteed to have 5 data points,
        // and the datapoint increment does not reset per component. This is to ensure there isn't
        // some weird, unexpected entanglement between the graphs (i.e. to ensure the output of
        // one graph doesn't depend on the output of another)
        let datapoint = 5 * chartIdx + i;

        cy.get(htmlId + " .recharts-line-dots")
          .children()
          .eq(i)
          .trigger("mousemove", { force: true })
          .wait(200);

        cy.get(htmlId + " .recharts-tooltip-label").should("have.text", `${i + 1}`);
        cy.get(htmlId + " .recharts-tooltip-item-value").should("have.text", `${datapoint}`);
      }

      ++chartIdx;
    }
  });
});

export {};
