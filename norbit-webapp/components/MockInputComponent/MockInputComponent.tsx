import React from 'react';
import {MockInputProps} from "./types";

/**
 * This component deals with mocking input in integration tests, as there's no trivial way to mock
 * the Amplify connection within them due to the server being run separately. 
 * This provides a hidden input field (when enabled; this should not be present unless
 * it's determined that amplify is in a mocked state) that tests can use to sneak in data.
 * This is not _really_ in the spirit of integration testing, but mocking amplify is far
 * too complex for me to do, and involves using a command line utility I don't have access to.
 *
 * Using component tests to fill the gap (which are mockable and much more controllable)
 * should allow for the entire system to be tested regardless.
 */
export const MockInputComponent: React.FC<MockInputProps> = ({data, setData}) => {
  const updateData = (ev: React.KeyboardEvent<HTMLInputElement>) => {

    ev.preventDefault();
    if (ev.key != "Enter") {
      return;
    }
    
    const elem = ev.currentTarget as HTMLInputElement;
    let newData = elem.value;
    if (newData != null && newData.length != 0) {
      // Not all the data is floats, but it's easier to work with.
      let num = parseFloat(newData);

      let dataEntry = {
        timestamp: (data.length + 1).toString(),
        datapoint: num
      };

      setData([...data, dataEntry]);
    }

    // Wipe the input field
    elem.value = "";
  };

  return (
    <input type="number" style={{display: 'none'}} onKeyUp={updateData}/>
  );
};
