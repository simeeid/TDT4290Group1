import { useEffect } from "react";
import { Amplify, PubSub } from "aws-amplify";
import { AWSIoTProvider } from "@aws-amplify/pubsub";
import { useDispatch, useSelector } from "react-redux";
import { setInitialized } from "redux/slices/amplifySlice";
import { RootState } from "redux/store";
import { amplifyConfig } from "amplify-config";
import React from "react";

interface AmplifyInitializerProps {
  children: React.ReactNode;
}

const AmplifyInitializer: React.FC<AmplifyInitializerProps> = ({ children }) => {
  const dispatch = useDispatch();
  let { initialized, isMock } = useSelector((state: RootState) => state.amplify);

  useEffect(() => {
    if (!initialized) {
      if (!isMock) {
        console.log("Running Amplify in live mode");
        Amplify.configure(amplifyConfig);
        PubSub.addPluggable(
          new AWSIoTProvider({
            aws_pubsub_region: process.env.NEXT_PUBLIC_REGION,
            aws_pubsub_endpoint: `wss://${process.env.NEXT_PUBLIC_MQTT_ID}/mqtt`,
          })
        );
      } else {
        console.log("Mocking Amplify");
      }
      dispatch(setInitialized(true));
      initialized = true; // eslint-disable-line react-hooks/exhaustive-deps
    }
  }, [dispatch, initialized, isMock]);

  return <>{children}</>;
};

export default AmplifyInitializer;
