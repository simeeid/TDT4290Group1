import { TamplifyInstance } from "@/dashboard/Dashboard";
import { useEffect } from "react";


export const useSubscribeToTopics = (topic: string, amplifyInstance:TamplifyInstance, setState: React.Dispatch<React.SetStateAction<any>> ) => {

  useEffect(() => {
    const subscription = amplifyInstance.PubSub.subscribe(topic).subscribe({
      next: (data: any) => {
        setState(data.value);
        //TODO remove this logstatement after finihing the implementation
        console.log('Message received', data.value.payload);
      },
      error: (error: any) => {
        console.error(error);
      },
      close: () => {
        console.log('Subscription closed');
      }
    });
    return () => {if(subscription) subscription.unsubscribe()};
  }, [amplifyInstance, setState, topic]);

}