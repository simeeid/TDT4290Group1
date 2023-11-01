import SensorConfigurationPanel from "@/sensorConfiguration/SensorConfigurationPanel";
import React from "react";
import { store } from "@redux/store";
import { sensorConfig, SensorConfig } from "@redux/slices/SensorConfig";

describe("Header", () => {
  beforeEach(() => {
    cy.mount(<SensorConfigurationPanel />);
  });

  const validateStore = (conf: SensorConfig) => {
    cy.wrap(store).invoke("getState").should("deep.contain", {
      sensorConfig: conf,
    });
  };

  it("Should render", () => {
    cy.get("#sensor-panel").should("exist").and("be.visible");
  });
  it("Should affect redux", () => {
    cy.get("#enable-accelerometer").scrollIntoView();
    let state: SensorConfig = {
      ...sensorConfig.getInitialState(),
    };
    cy.log("State: ", state);
    const ids: Array<[string, keyof SensorConfig]> = [
      ["#enable-accelerometer", "accelerometer"],
      ["#enable-temperature", "temperature"],
      ["#enable-light", "light"],
      ["#enable-sound", "sound"],
    ];

    validateStore(state);
    for (const [id, sensor] of ids) {
      // The inner loop ensure each checkbox is checked and unchecked. Full state management is
      // handled by the integration tests, but as long as the true and false values are updated,
      // any problems are not sourced from the config panel
      for (let i = 0; i < 2; ++i) {
        cy.get(id).scrollIntoView();
        cy.get(id).click();
        cy.log("State: ", state);
        // This is stupid, but just
        //     state[sensor] = !state[sensor]
        // does nothing. Thanks, JavaScript!
        state = {
          ...state,
          [sensor]: !state[sensor],
        };
        cy.log("State: ", state);
        validateStore(state);
      }
    }
  });
});

export {};
