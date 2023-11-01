import { TamplifyInstance } from "@/dashboard/Dashboard";
import React, { useEffect } from "react";

export const useSubscribeToTopics = (
  topic: string,
  amplifyInstance: TamplifyInstance | null,
  setState: React.Dispatch<React.SetStateAction<any>>
) => {
  useEffect(() => {
    if (amplifyInstance == null) {
      return;
    }
    const subscription = amplifyInstance.PubSub.subscribe(topic).subscribe({
      next: (data: any) => {
        setState(data.value);
        //TODO remove this logstatement after finihing the implementation
        console.log("Message received", data.value.payload);
      },
      error: (error: any) => {
        console.error(error);
      },
      close: () => {
        console.log("Subscription closed");
      },
    });
    return () => {
      if (subscription) subscription.unsubscribe();
    };
  }, [amplifyInstance, setState, topic]);
};
